extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var level: BaseLevel
var changing_level: bool = false

func _ready():
	var m: Message = Message.Create(self, 'Level 1')
	await self._play('FadeIn')
	await m.display(3.0)
	self.level = GameState.load_level(self)
	GameState.after_growth.connect(self._on_after_growth)
	GameState.player_died.connect(self._on_player_died)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		self.get_tree().quit()

func _play(name: String) -> void:
	self.animation_player.current_animation = name
	await self.animation_player.animation_finished

func _on_after_growth(_ignored: int) -> void:
	if self.changing_level:
		return
	if self.level.organism.is_complete():
		self.changing_level = true
		var m: Message = Message.Create(self, "You've Won!")
		await m.display(3.0)
		await self._play('FadeOut')
		self.level = GameState.load_level(self)
		m = Message.Create(self, "Level %s" % (GameState.level_num + 1))
		await self._play('FadeIn')
		await m.display(3.0)
		self.changing_level = false

func _on_player_died() -> void:
	var m: Message = Message.Create(self, "You've Died!")
	await m.display(3.0)
	await self._play('FadeOut')
	get_tree().quit()
	
