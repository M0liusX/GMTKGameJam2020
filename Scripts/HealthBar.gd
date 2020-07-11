extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var maxHealth = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	value = maxHealth
	pass # Replace with function body.

func _updateHealth(healthChangeAmount):
	if value + healthChangeAmount < 0:
		value = 0
	else:
		value = int(value+healthChangeAmount) % maxHealth
# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = 100
func _process(_delta):
	if i == 0:
		print("Value:", value)
		_updateHealth(-5)
		i = 100
	i -= 1
	print(i)
#	pass
