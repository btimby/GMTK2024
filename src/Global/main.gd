extends Node2D

var player_scene: PackedScene = preload("res://Entities/Player/player.tscn")
var current_level: Node = null

@onready var player: Node = player_scene.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	self._load_level(GameState.level)
	self.add_child(self.player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _load_level(num: int):
	if self.current_level:
		self.current_level.queue_free()

	self.current_level = GameState.LEVELS[num].instantiate()
	self.add_child(self.current_level)
