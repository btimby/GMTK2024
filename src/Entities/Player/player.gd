class_name Player extends CharacterBody2D

const BRAIN_SCENE: PackedScene = preload("res://Entities/Cells/BrainCell/brain_cell.tscn")

# Settings
@export var max_energy: int = 200
@export var max_speed: int = 400

# Player state
var energy: int = 100
var cells: Array[BaseCell] = []
var speed = 200
var brain: Node2D

func _ready():
	self.brain = BRAIN_SCENE.instantiate()
	self._add_cell(self.brain, null, Vector2.ZERO)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	self.velocity = direction * self.speed
	if not self.move_and_slide():
		return

func add_cell(player_ap: AttachmentPoint, cell_ap: AttachmentPoint) -> void:
	self.call_deferred('_calc_add_cell', player_ap, cell_ap)

func _calc_add_cell(player_ap: AttachmentPoint, cell_ap: AttachmentPoint) -> void:
	var offset: Vector2
	if player_ap.cell != self.brain:
		offset = player_ap.global_position - self.global_position
	else:
		offset = -cell_ap.position
	self._add_cell(cell_ap.cell, player_ap, offset)

func _add_cell(cell: BaseCell, follow: Node2D, offset: Vector2) -> void:
	var parent: Node2D = cell.get_parent()
	if parent:
		parent.remove_child(cell)
	self.add_child(cell)
	if follow:
		cell.follow_at_offset(follow, offset)
