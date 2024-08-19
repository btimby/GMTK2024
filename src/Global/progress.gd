class_name Progress

var total: int = 0
var completed: int = 0

signal completion

static func Create(total: int = 0) -> Progress:
	var progress = Progress.new()
	progress.total = total
	return progress

func complete(count: int = 1) -> void:
	self.completed += count
	if self.completed >= self.total:
		self.completion.emit()
