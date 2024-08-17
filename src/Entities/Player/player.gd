extends CharacterBody2D

const BRAIN: PackedScene = preload("res://Entities/Cells/Brain/brain.tscn")

# Settings
@export var max_energy: int = 200
@export var max_speed: int = 400

# Player state
var energy: int = 100
var cells: Array[BaseCell] = []

var speed = 100

func _ready():
	self._add_cell(BRAIN)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	self.velocity = direction * self.speed
	self.move_and_slide()

func _add_cell(cell_scene: PackedScene):
	var cell: = cell_scene.instantiate()
	self.cells.append(cell)
	self.add_child(cell)
