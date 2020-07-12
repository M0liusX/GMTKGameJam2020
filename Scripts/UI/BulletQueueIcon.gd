extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path = "res://Assets/Art/BulletIcons/"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _updateIcon(bulletType):
	var bulletIcon = path+bulletType
	texture = load(bulletIcon)
	#print("done")

func _getBulletType():
	# get a num between 1 and 5
	match randi()%5+1:
		1: return "cannon.png"
		2: return "lazer.png"
		3: return "flamethrower.png"
		4: return "rapidfire.png"
		5: return "explosive.png"
		_: return "basic.png"
		
#var i = 100
#func _process(_delta):
#	if i == 0:
#		var nextBullet = _getBulletType()
#		_updateIcon(nextBullet)
#		i = 100
#	i = i-1
	#print(i)
