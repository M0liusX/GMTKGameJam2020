extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path = "res://Assets/Art/LawIcons/"
var law = -1
export var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func updateIcon():
	if index < Laws.currentLaws.size():
		self.law = Laws.currentLaws[index]
	var bulletIcon = path+getLawType()
	texture = load(bulletIcon)
	#print("done")

func getLawType():
	# get a num between 1 and 5
	match law:
		-1: return "Empty.png"
		0: return "Reverse.png"
		1: return "Mouse.png"
		2: return "Double.png"
		3: return "Star.png"
		_: return "Heart.png"

func _process(_delta):
	updateIcon()
