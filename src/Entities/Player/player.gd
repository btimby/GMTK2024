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
	# NOTE: Not used by player
	self.joint.queue_free()

func _physics_process(delta: float) -> void:
	var rotation: float = 0.0
	var direction = Input.get_vector("left", "right", "up", "down")
	var velocity = direction * self.speed
	self.apply_force(velocity)
	self._swim_animation(direction)

func _next_generation():
	self.energy = 0
	self.generation += 1
	self.next_growth *= 1.2

func _grow():
	GameState.before_growth.emit()
	var progress: Progress = Progress.Create()
	GameState.organism.each('split', progress)
	await progress.completion
	GameState.after_growth.emit(self.next_growth)

func add_energy(amount: int) -> void:
	print('Energy:', self.energy)
	print('Amount:', amount)
	self.energy = clamp(self.energy + amount, 0, self.next_growth)
	print('Energy:', self.energy)
	if self.energy == 0:
		# Remove a cell
		if not GameState.organism.remove():
			# No cell to remove? Die then.
			GameState.player_died.emit()
		return
	if self.energy < self.next_growth:
		return
	self._next_generation()
	self._grow()
