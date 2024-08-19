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
@export var cell_angular_limit: float = 0.2

@onready var cell_scene: PackedScene = preload("res://Entities/Cells/BaseCell/base_cell.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var energy: int = 0
var next_growth: int = 100
var growing: bool = false
var coords: Vector2

static func Create(parent: Node2D, coords: Vector2, position: Vector2) -> BaseCell:
	var cell_scene: PackedScene = preload("res://Entities/Cells/BaseCell/base_cell.tscn")
	var cell: BaseCell = cell_scene.instantiate()
	parent.add_child(cell)
	cell.coords = coords
	cell.position = position
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

func _add_cell(dir: Constants.DIR) -> void:
	#var cell: BaseCell = cell_scene.instantiate()
	var new_coords: Vector2 = GameState.organism.move(self.coords, dir)
	var new_position = self.position + Constants.DIR_VECTORS[dir] * self.grow_distance
	var cell: BaseCell = BaseCell.Create(self.get_parent(), new_coords, new_position)
	GameState.organism.insert(new_coords, cell)
	var pin: PinJoint2D = PinJoint2D.new()
	pin.node_a = self.get_path()
	pin.node_b = cell.get_path()
	pin.angular_limit_enabled = true
	pin.angular_limit_lower = -self.cell_angular_limit
	pin.angular_limit_upper = self.cell_angular_limit
	self.add_child(pin)

func _grow(dir: Constants.DIR, progress: Progress) -> void:
	progress.total += 1
	self.growing = true
#	var margin: CollisionShape2D = CollisionShape2D.new()
#	var shape: CircleShape2D = CircleShape2D.new()
#	shape.radius = 112
#	margin.shape = shape
#	self.add_child(margin)
	self.animation_player.current_animation = 'PreGrow'
	await self.animation_player.animation_finished
	self.growing = false
#	self.remove_child(margin)
	self._add_cell(dir)
	self.animation_player.current_animation = 'Idle'
	progress.complete()

func grow(progress: Progress) -> void:
	var to_grow: Array[BaseCell] = []
	for dir in [Constants.DIR.UP, Constants.DIR.RIGHT, Constants.DIR.DOWN, Constants.DIR.LEFT]:
		if GameState.level.organism.is_open(self.coords, dir):
			self._grow(dir, progress)
			return

func add_energy(amount: int) -> void:
	GameState.player.add_energy(amount)
