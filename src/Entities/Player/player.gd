class_name Player extends BaseCell

static func Create(parent: Node2D, coords: Vector2, position: Vector2) -> Player:
	var player_scene: PackedScene = preload("res://Entities/Player/player.tscn")
	var player: Player = player_scene.instantiate()
	parent.add_child(player)
	player.coords = coords
	player.position = position
	return player

func _ready():
	GameState.energy_changed.emit(self.energy)

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
		GameState.before_growth.emit()
		var progress: Progress = Progress.Create()
		GameState.organism.each('grow', progress)
		await progress.completion
		self.energy = self.energy - self.next_growth
		self.next_growth *= 1.2
		GameState.after_growth.emit(self.next_growth)
