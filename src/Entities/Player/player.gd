class_name Player extends CharacterBody2D

const BRAIN: PackedScene = preload("res://Entities/Cells/BrainCell/brain_cell.tscn")

# Settings
@export var max_energy: int = 200
@export var max_speed: int = 400

# Player state
var energy: int = 100
var cells: Array[BaseCell] = []
var speed = 200

func _ready():
	var brain: BaseCell = BRAIN.instantiate()
	self.add_cell(brain, Vector2(0, 0))

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	self.velocity = direction * self.speed
	if not self.move_and_slide():
		return
#	for i in self.get_slide_collision_count():
#		var col = self.get_slide_collision(i)
#		var body = col.get_collider()
#		if body is not BaseCell:
#			continue
#		var cell: BaseCell = body
#		self.add_cell(body, cell.global_position - self.global_position)

func add_cell(cell: BaseCell, position: Vector2) -> void:
	var parent: Node2D = cell.get_parent()
	if parent:
		parent.remove_child(cell)
	self.add_child(cell)
	cell.position = position
