class_name BaseCell extends RigidBody2D

var attachments: Array[Node2D] = []
var following: Node2D = null
var offset: Vector2

func _ready():
	self.contact_monitor = true
	self.max_contacts_reported = 16

func _process(delta):
	pass

#func _on_body_entered(body: Node2D) -> void:
#	print(body)

#func _physics_process(delta: float) -> void:
#	for body in self.get_colliding_bodies():
#		if body is not BaseCell:
#			return
#		var cell: BaseCell = body
#		cell.follow(self)
