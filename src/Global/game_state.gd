class_name GlobalState extends Node

# Global signals
signal energy_changed
signal before_growth
signal after_growth

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

	self.level_num = num
	self.level = Constants.LEVELS[num].instantiate()
	parent.add_child(self.level)
	self.level.create_player()

	return self.level
