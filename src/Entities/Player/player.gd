class_name Player extends RigidBody2D

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

@onready var cell_scene: PackedScene = preload("res://Entities/Cells/BaseCell/base_cell.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var energy: int = 0 :
	set(value):
		energy = value
		GameState.energy_changed.emit(value)
		if energy >= next_growth:
			self._grow()

var next_growth: int = 100 :
	set(value):
		next_growth = value
		GameState.next_growth_changed.emit(value)

var cells: Array[BaseCell] = []

func _ready():
	GameState.energy_changed.emit(self.energy)
	self.animation_player.current_animation = 'Idle'

func _swim_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		self.animation_player.current_animation = 'Idle'
		return

	var angle: float = snappedf(direction.angle(), PI/4) / (PI/4)
	var octant: int = wrapi(int(angle), 0, 8)
	print(octant)
	self.animation_player.current_animation = SWIM_ANIMATIONS.get(octant, 'Idle')

func _physics_process(delta: float) -> void:
	var rotation: float = 0.0
	var direction = Input.get_vector("left", "right", "up", "down")
	var velocity = direction * self.speed
	self.apply_force(velocity)
	self._swim_animation(direction)

func _grow() -> void:
	var cell: BaseCell = cell_scene.instantiate()
	self.get_parent().add_child(cell)
	cell.position = self.position + Vector2(104, 0)
	var pin: PinJoint2D = PinJoint2D.new()
	pin.node_a = self.get_path()
	pin.node_b = cell.get_path()
	self.add_child(pin)
	self.cells.append(cell)
	self.energy = self.energy - self.next_growth
	self.next_growth *= 1.2
