class_name GlobalState
extends Node

const LEVELS: Array[PackedScene] = [
	preload("res://Levels/Level0/level0.tscn"),
]

# Configrable variables
@export var start_level: int = 0

# Global signals
signal energy_changed
signal next_growth_changed

# Global state
var level: int = start_level
