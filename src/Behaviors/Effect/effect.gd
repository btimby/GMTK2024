class_name Effect extends Node2D

@export var target_area: Area2D
@export var give_energy: int = 0

func _ready() -> void:
	if not self.target_area:
		push_warning('Effect cannot function without an Area2D as Target area')
		return
	self.target_area.body_entered.connect(self._on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is not BaseCell:
		return
	if self.give_energy != 0:
		GameState.player.add_energy(self.give_energy)
	self.get_parent().queue_free()
