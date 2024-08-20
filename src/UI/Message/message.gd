class_name Message extends Node2D

const MESSAGE_SCENE = preload("res://UI/Message/message.tscn")

@onready var label: Label = $CanvasLayer/Node2D/CenterContainer/Label
@onready var container: Node2D = $CanvasLayer/Node2D

signal done

static func Create(parent: Node2D, message: String) -> Message:
	var m: Message = MESSAGE_SCENE.instantiate()
	parent.add_child(m)
	m.label.text = message
	return m

func _ready() -> void:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var label_size: Vector2 = self.label.get_rect().size
	self.container.position = (screen_size - label_size) / 2

func display(duration: float = 1.0) -> Signal:
	get_tree().paused = true
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	timer.timeout.connect(self._on_complete)
	return self.done

func _on_complete() -> void:
	get_tree().paused = false
	self.queue_free()
	self.done.emit()
