class_name BaseCell extends RigidBody2D

var speed: float = 100
var follow: Node2D
var offset: Vector2

func _physics_process(delta: float) -> void:
	if not self.follow:
		return
	var direction: Vector2 = (self.follow.position + offset) - self.position
	self.velocity = direction * delta * speed
#	self.move_and_slide()

func follow_at_offset(obj: Node2D, offset: Vector2) -> void:
	self.follow = obj
	self.offset = offset
	self.position = obj.position + offset
