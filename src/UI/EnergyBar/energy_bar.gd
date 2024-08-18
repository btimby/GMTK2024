class_name EnergyBar extends Node2D

@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

func _ready() -> void:
	GameState.energy_changed.connect(self._on_energy_changed)
	GameState.next_growth_changed.connect(self._on_next_growth_changed)

func _on_energy_changed(value: int) -> void:
	self.progress_bar.value = value

func _on_next_growth_changed(value: int) -> void:
	self.progress_bar.max_value = value
