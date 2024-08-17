extends Node2D

var player_scene: PackedScene = preload("res://Entities/Player/player.tscn")
var current_level: Node = null

@onready var player: Node = player_scene.instantiate()

func _ready():
	self._load_level(GameState.level)
	self.current_level.add_child(self.player)
	self.player.position = self.current_level.get_node("Start").position

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		self.get_tree().quit()

func _load_level(num: int):
	if self.current_level:
		self.current_level.queue_free()

	self.current_level = GameState.LEVELS[num].instantiate()
	self.add_child(self.current_level)
