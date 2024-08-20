class_name Player extends BaseCell

var energy: int :
	set(value):
		energy = value
		GameState.energy_changed.emit(energy)

var next_growth: int = 100 :
	set(value):
		next_growth = value
		GameState.next_growth_changed.emit(next_growth)

var generation: int :
	set(value):
		generation = value
		GameState.generation_changed.emit(generation)

static func Create(coords: Vector2) -> Player:
	var player_scene: PackedScene = preload("res://Entities/Player/player.tscn")
	var player: Player = player_scene.instantiate()
	player.coords = coords
	return player

func _ready():
	self.energy = 0
	self.generation = 1

func _physics_process(delta: float) -> void:
	var rotation: float = 0.0
	var direction = Input.get_vector("left", "right", "up", "down")
	var velocity = direction * self.speed
	self.apply_force(velocity)
	self._swim_animation(direction)

func add_energy(amount: int) -> void:
	self.energy += amount
	GameState.energy_changed.emit(self.energy)
	if self.energy >= self.next_growth:
		self.energy = self.energy - self.next_growth
		self.generation += 1
		self.next_growth *= 1.2
		GameState.before_growth.emit()
		var progress: Progress = Progress.Create()
		GameState.organism.each('grow', progress)
		await progress.completion
		GameState.after_growth.emit(self.next_growth)
