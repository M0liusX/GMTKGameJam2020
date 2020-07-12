extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var trueHealth = 100.0
var maxHealth = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	value = maxHealth
	pass # Replace with function body.

func updateHealth(healthChangeAmount):
	if value + healthChangeAmount < 0:
		value = 0
		trueHealth = 0
	else:
		trueHealth += healthChangeAmount
		value = int(trueHealth) % maxHealth
	return value
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):

