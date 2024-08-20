class_name GlobalState extends Node

# Global signals
signal energy_changed
signal before_growth
signal after_growth
signal next_growth_changed
signal generation_changed

# Global state
var level_num: int = -1
var level: BaseLevel
var player: Player :
	get():
		if not level:
			return null
		return level.player
var organism: Organism :
	get():
		if not level:
			return null
		return level.organism

func load_level(parent: Node2D, num: int = -1):
	if num == -1:
		num = self.level_num + 1
	if self.level:
		self.level.queue_free()

	if num > Constants.LEVELS.size() - 1:
		self.get_tree().quit()
		return

	self.level_num = num
	self.level = Constants.LEVELS[num].instantiate()
	parent.add_child(self.level)
	self.level.create_player()

	return self.level
