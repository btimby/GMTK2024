class_name BaseCell extends RigidBody2D

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
@export var grow_distance: int = 104

@onready var cell_scene: PackedScene = preload("res://Entities/Cells/BaseCell/base_cell.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
#@onready var joint: PinJoint2D = $PinJoint2D
@onready var joint: DampedSpringJoint2D = $DampedSpringJoint2D

var growing: bool = false
var coords: Vector2

static func Create(coords: Vector2) -> BaseCell:
	var cell_scene: PackedScene = preload("res://Entities/Cells/BaseCell/base_cell.tscn")
	var cell: BaseCell = cell_scene.instantiate()
	# parent.add_child(cell)
	cell.coords = coords
	return cell

func _ready():
	self.animation_player.current_animation = 'Idle'

func _swim_animation(direction: Vector2) -> void:
	if self.growing:
		return

	if direction == Vector2.ZERO:
		self.animation_player.current_animation = 'Idle'
		return

	var angle: float = snappedf(direction.angle(), PI/4) / (PI/4)
	var octant: int = wrapi(int(angle), 0, 8)
	self.animation_player.current_animation = SWIM_ANIMATIONS.get(octant, 'Idle')

func _find_direction(dir: Constants.DIR = Constants.DIR.NONE) -> Constants.DIR:
	if dir != Constants.DIR.NONE:
		return dir
	for d in [Constants.DIR.UP, Constants.DIR.LEFT, Constants.DIR.DOWN, Constants.DIR.RIGHT]:
		if self.cells[d] == null:
			return d
	return Constants.DIR.NONE

func _create_cell(dir: Constants.DIR) -> BaseCell:
	var new_coords: Vector2 = GameState.organism.move(self.coords, dir)
	var cell: BaseCell = BaseCell.Create(new_coords)
	GameState.organism.insert(new_coords, Constants.SLOT.NONE)
	return cell
	
func _add_cell(cell: BaseCell, dir: Constants.DIR) -> void:
	self.get_parent().add_child(cell)
	cell.global_position = self.global_position + Constants.DIR_VECTORS[dir] * self.grow_distance
	var joint: DampedSpringJoint2D = DampedSpringJoint2D.new()
	cell.joint.node_a = self.get_path()
	cell.joint.node_b = cell.get_path()
	cell.joint.global_position = self.global_position
	GameState.organism.insert(cell.coords, cell)

func _split(dir: Constants.DIR, progress: Progress) -> void:
	progress.total += 1
	var was_growing: bool = self.growing
	self.growing = true
#	var margin: CollisionShape2D = CollisionShape2D.new()
#	var shape: CircleShape2D = CircleShape2D.new()
#	shape.radius = 112
#	margin.shape = shape
#	self.add_child(margin)
	var cell: BaseCell = self._create_cell(dir)
	if not was_growing:
		self.animation_player.current_animation = 'PreSplit'
	await self.animation_player.animation_finished
	self.growing = false
#	self.remove_child(margin)
	self._add_cell(cell, dir)
	self.animation_player.current_animation = 'Idle'
	progress.complete()

func split(progress: Progress) -> void:
	var to_grow: Array[BaseCell] = []
	for dir in [Constants.DIR.UP, Constants.DIR.RIGHT, Constants.DIR.DOWN, Constants.DIR.LEFT]:
		if GameState.level.organism.is_open(self.coords, dir):
			self._split(dir, progress)
			return
