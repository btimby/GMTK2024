extends RigidBody2D

const SWIM_ANIMATIONS = {
	0: 'Swim0', # Right
	1: 'Swim1', # Down/ right
	2: 'Swim2', # Down 
	3: 'Swim3', # Down / left
	4: 'Swim4', # Left
	5: 'Swim5', # Up / left
	6: 'Swim6', # Up
	7: 'Swim7', # Up / right
}

@export var speed: int = 2400
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	self.animation_player.current_animation = 'Idle'

func _swim_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		self.animation_player.current_animation = 'Idle'
		return

	var angle: float = snappedf(direction.angle(), PI/4) / (PI/4)
	var octant: int = wrapi(int(angle), 0, 8)
	print(octant)
	self.animation_player.current_animation = SWIM_ANIMATIONS.get(octant, 'Idle')

func _physics_process(delta: float) -> void:
	var rotation: float = 0.0
	var direction = Input.get_vector("left", "right", "up", "down")
	var velocity = direction * self.speed
	self.apply_force(velocity)
	self._swim_animation(direction)
