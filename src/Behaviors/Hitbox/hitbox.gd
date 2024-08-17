class_name Hitbox extends Area2D

@export var health: Health

func damage(attack: Attack):
	if self.health:
		self.health.damage(attack)

func _on_area_entered(area: Area2D) -> void:
	if area is Attack:
		var attack: Attack = area
		damage(attack)
