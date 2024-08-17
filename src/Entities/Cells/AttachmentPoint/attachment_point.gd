class_name AttachmentPoint extends Node2D

@onready var area: Area2D = get_node('Area2D')
@onready var collision_shape: CollisionShape2D = get_node("Area2D/CollisionShape2D")
@onready var cell: Node2D = get_parent().get_parent()

var pair: AttachmentPoint = null

func _on_area_2d_area_entered(area: Area2D) -> void:
	var ap: AttachmentPoint = area.get_parent()
	if self.is_attached():
		return
	# this event can fire with either player or cell area as the parameter.
	if self.cell.get_parent().has_method('add_cell'):
		var player = self.cell.get_parent()
		player.add_cell(self, ap)
		self.attach(ap)
	if ap.cell.get_parent().has_method('add_cell'):
		var player = ap.cell.get_parent()
		player.add_cell(ap, self)
		self.attach(ap)

func is_attached() -> bool:
	return self.pair != null

func attach(ap: AttachmentPoint) -> bool:
	if self.pair:
		return false
	self.pair = ap
	self.area.set_deferred('collision_layer', 16)
	self.collision_shape.set_deferred('disabled', true)
	ap.attach(self)
	return true
