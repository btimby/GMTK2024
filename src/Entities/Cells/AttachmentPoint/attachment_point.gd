class_name AttachmentPoint extends Node2D

@onready var area: Area2D = get_node('Area2D')
@onready var collision_shape: CollisionShape2D = get_node("Area2D/CollisionShape2D")
@onready var cell: Node2D = get_parent().get_parent()

var disabled: bool = false
var pair: AttachmentPoint = null

func _on_area_2d_area_entered(area: Area2D) -> void:
	print('Attachment: %s<->%s' % [self, area])
	var ap: AttachmentPoint = area.get_parent()
	if not self.attach(ap):
		return
	if not ap.attach(self):
		return
	var player: Node2D
	var cell: BaseCell
	if self.cell.get_parent().has_method('add_cell'):
		player = self.cell.get_parent()
		cell = ap.cell
	else:
		player = ap.cell.get_parent()
		cell = self.cell
	player.add_cell(cell, cell.global_position - player.global_position)

func disable() -> bool:
	var was_disabled: bool = self.disabled
	self.disabled = true
	self.area.collision_layer = 16
	self.collision_shape.disabled = true
	return was_disabled

func attach(ap: AttachmentPoint) -> bool:
	if self.pair:
		return false
	self.pair = ap
	return true
