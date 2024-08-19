class_name Constants

const LEVELS: Array[PackedScene] = [
	preload("res://Levels/Level0/level0.tscn"),
	preload("res://Levels/Level1/level1.tscn"),
]

enum DIR {
	NONE, UP, LEFT, DOWN, RIGHT
}

const DIR_VECTORS: Dictionary = {
	DIR.NONE: Vector2.ZERO,
	DIR.UP: Vector2(0, -1),
	DIR.LEFT: Vector2(-1, 0),
	DIR.DOWN: Vector2(0, 1),
	DIR.RIGHT: Vector2(1, 0),
}

const DIR_FLIP: Dictionary = {
	DIR.NONE: DIR.NONE,
	DIR.UP: DIR.DOWN,
	DIR.LEFT: DIR.RIGHT,
	DIR.DOWN: DIR.UP,
	DIR.RIGHT: DIR.LEFT,
}

enum SLOT {
	NONE,
	BASE,
	PLAY,
}

const OPEN_SLOTS = [
	SLOT.BASE,
	SLOT.PLAY,
]
