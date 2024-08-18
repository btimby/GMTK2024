extends RigidBody2D

@export var speed: int = 2400

func _physics_process(delta: float) -> void:
	var rotation: float = 0.0
	var direction = Input.get_vector("left", "right", "up", "down")
	var velocity = direction * self.speed
	self.apply_force(velocity)
