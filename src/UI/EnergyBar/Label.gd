extends Label
var energy = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	energy += 0.1
	text = str(energy)
	$ProgressBar.value = energy
