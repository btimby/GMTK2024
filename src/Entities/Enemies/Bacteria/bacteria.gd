class_name Bacteria extends RigidBody2D

const BACTERIA_SCENE: PackedScene = preload("res://Entities/Enemies/Bacteria/bacteria.tscn")

@export var steering_duration: float = 0.3
@export var speed: float = 140
@export var chance_to_steer: float = 0.005
@export var chance_to_split: float = 0.0005

var direction: Vector2 = Vector2(randf(), randf()).normalized()
var target: Variant = null
var steering: Tween = null

func _steer(direction):
	if self.steering:
		self.steering.kill()
	self.steering = self.create_tween()
	self.steering.tween_property(self, 'direction', direction, self.steering_duration)
	self.steering.tween_callback(func(): self.steering = null)

func _maybe_steer(chance: float = chance_to_steer) -> void:
	if randf() > chance:
		return
	self._steer(self.direction.rotated(randf() * 20))

func _chase_target() -> void:
	self._steer(self.global_position.direction_to(self.target.global_position))

func _maybe_split(chance: float = chance_to_split) -> void:
	if randf() > chance:
		return
	var bacteria: Bacteria = BACTERIA_SCENE.instantiate()
	self.get_parent().add_child(bacteria)
	bacteria.global_position = self.global_position + (Vector2.UP.rotated(randf() * 360) * 20)

func _process(delta):
	if self.target:
		self._chase_target()
	else:
		self._maybe_steer()
	self._maybe_split()
	self.rotation = self.direction.angle()
	if move_and_collide(self.direction * delta * self.speed):
		self._steer(self.direction.rotated(20))

func _on_sight_body_entered(body: Node2D) -> void:
	if body is Player or body is BaseCell:
		self.target = body

func _on_sight_body_exited(body: Node2D) -> void:
	if self.target == body:
		self.target = null
