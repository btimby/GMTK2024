class_name ZoomingCamera extends Camera2D

@export var min_zoom := 0.1
@export var max_zoom := 2.0
@export var zoom_factor := 0.05
@export var zoom_duration := 0.2

func _ready():
	GameState.generation_changed.connect(self._on_generation_changed)

func _zoom(value: float) -> void:
	var zoom_level: float  = clamp(self.zoom.x + value, self.min_zoom, self.max_zoom)
	var tween := get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(tween.TRANS_SINE)
	tween.tween_property(
		self, 'zoom', Vector2(zoom_level, zoom_level), self.zoom_duration
	)

func _process(delta: float) -> void:
	if Input.is_action_pressed('zoom_in'):
		self._zoom(self.zoom_factor)
	if Input.is_action_pressed('zoom_out'):
		self._zoom(-self.zoom_factor)

func _on_generation_changed(value: int) -> void:
	self._zoom(-self.zoom_factor)
