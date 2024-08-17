class_name Cell extends Node2D

@export var sprite: Texture
@onready var sprite_2d = %Sprite2D

func _ready():
	self.sprite_2d.texture = sprite

func _process(delta):
	pass
