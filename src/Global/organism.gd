class_name Organism

var structure: Array[Array] = []

static func Create(blueprint: Array[Array]) -> Organism:
	var org: Organism = Organism.new()
	org.structure = blueprint.duplicate()
	return org

func _check_coords(coords: Vector2) -> bool:
	var y_size: int = self.structure.size() - 1
	if coords.y < 0 or coords.y > y_size:
		return false
	var x_size: int = self.structure[coords.y].size() - 1
	if coords.x < 0 or coords.x > x_size:
		return false
	return true

func find(slot: Constants.SLOT) -> Vector2:
	for y in range(self.structure.size()):
		var row: Array = structure[y]
		for x in range(row.size()):
			if row[x] == slot:
				return Vector2(x, y)
	return Vector2.INF

func insert(coords: Vector2, obj: Variant) -> bool:
	if not self._check_coords(coords):
		return false
	var row: Array = self.structure[coords.y]
	if row[coords.x] not in Constants.OPEN_SLOTS:
		return false
	row[coords.x] = obj
	return true

func inspect(coords: Vector2) -> Variant:
	if not self._check_coords(coords):
		return Constants.SLOT.NONE
	return self.structure[coords.y][coords.x]

func is_open(coords: Vector2, dir: Constants.DIR = Constants.DIR.NONE) -> bool:
	var new_coords: Vector2 = self.move(coords, dir)
	var obj = self.inspect(new_coords)
	if obj not in Constants.OPEN_SLOTS:
		return false
	return true

func move(coords: Vector2, dir: Constants.DIR) -> Vector2:
	var new_coords: Vector2 = coords + Constants.DIR_VECTORS[dir]
	if not self._check_coords(new_coords):
		return Vector2.INF
	return new_coords

func up(coords: Vector2) -> Vector2:
	return self.move(coords, Constants.DIR.UP)

func down(coords: Vector2) -> Variant:
	return self.move(coords, Constants.DIR.DOWN)

func left(coords: Vector2) -> Variant:
	return self.move(coords, Constants.DIR.LEFT)

func right(coords: Vector2) -> Variant:
	return self.move(coords, Constants.DIR.RIGHT)

func each(method_name: String, arg: Variant, exclude: Array = []) -> void:
	for y in range(self.structure.size()):
		var row: Array = self.structure[y]
		for x in range(row.size()):
			var obj = self.structure[y][x]
			if not obj or obj is int:
				continue
			if not obj.has_method(method_name):
				continue
			if obj in exclude:
				continue
			obj.call(method_name, arg)

func is_complete() -> bool:
	for y in range(self.structure.size()):
		var row: Array = self.structure[y]
		for x in range(row.size()):
			if self.is_open(Vector2(x, y)):
				return false
	return true
