class_name Level1 extends BaseLevel

func _ready():
	self.BLUEPRINT = [
		[Constants.SLOT.NONE, Constants.SLOT.NONE, Constants.SLOT.BASE],
		[Constants.SLOT.NONE, Constants.SLOT.NONE, Constants.SLOT.BASE, Constants.SLOT.BASE],
		[Constants.SLOT.NONE, Constants.SLOT.BASE, Constants.SLOT.BASE, Constants.SLOT.BASE],
		[Constants.SLOT.BASE, Constants.SLOT.BASE, Constants.SLOT.PLAY, Constants.SLOT.BASE, Constants.SLOT.BASE],
		[Constants.SLOT.NONE, Constants.SLOT.BASE, Constants.SLOT.BASE, Constants.SLOT.BASE],
		[Constants.SLOT.NONE, Constants.SLOT.BASE, Constants.SLOT.BASE],
		[Constants.SLOT.NONE, Constants.SLOT.NONE, Constants.SLOT.BASE],
	]
