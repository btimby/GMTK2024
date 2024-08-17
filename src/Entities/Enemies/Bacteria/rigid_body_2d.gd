extends RigidBody2D
var x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(
			to_global(Vector2(0.5,0))-to_global(Vector2(0,0))
		)
	rotate((randf()-0.5)/25)
	x += 1
	if x > 250:
		$CPUParticles2D.emitting = true
		$CPUParticles2D2.emitting = true
		x = 0
