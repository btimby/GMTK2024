extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(
			to_global(Vector2(0.5,0))-to_global(Vector2(0,0))
		)
	rotate((randf()-0.5)/25)
