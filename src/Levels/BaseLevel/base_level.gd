class_name BaseLevel extends Node2D

@export var start: Node2D

var player: Player
var organism: Organism
var BLUEPRINT: Array[Array] = []

func create_player() -> Player:
	self.organism = Organism.Create(self.BLUEPRINT)
	var new_position: Vector2 = self.start.position
	var new_coords: Vector2 = self.organism.find(Constants.SLOT.PLAY)
	if new_coords == Vector2.INF:
		push_error("Could not locate player slot in %s blueprint" % self.name)
		return null
	self.player = Player.Create(new_coords)
	self.add_child(self.player)
	self.player.position = new_position
	self.organism.insert(new_coords, self.player)
	return self.player
