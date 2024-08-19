extends Node2D

var level: BaseLevel

func _ready():
	self.level = GameState.load_level(self)
	GameState.after_growth.connect(self._after_growth)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		self.get_tree().quit()

func _after_growth(_ignored: int):
	if self.level.organism.is_complete():
		self.level = GameState.load_level(self)
