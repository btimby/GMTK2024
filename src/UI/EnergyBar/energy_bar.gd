class_name EnergyBar extends Node2D

@export var fill_duration: float = 0.2
@export var grow_duration: float = 0.2

@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var label: Label = $CanvasLayer/Label

func _ready() -> void:
	GameState.energy_changed.connect(self._on_energy_changed)
	GameState.next_growth_changed.connect(self._on_next_growth_changed)
	GameState.generation_changed.connect(self._on_generation_changed)

func _on_energy_changed(value: int) -> void:
	var tween: Tween = self.create_tween()
	tween.tween_property(self.progress_bar, 'value', value, fill_duration)

func _on_next_growth_changed(value: int) -> void:
	var tween: Tween = self.create_tween()
	tween.tween_property(self.progress_bar, 'max_value', value, grow_duration)

func _on_generation_changed(value: int) -> void:
	self.label.text = 'Generation: %s' % value
