class_name Health extends Node2D

@export var max_health: int

@onready var health: int = max_health

func damage(attack: Attack):
	self.health -= attack.damage
	if self.health <= 0:
		self.get_parent().queue_free()
