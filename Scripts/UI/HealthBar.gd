extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var maxHealth = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	value = maxHealth
	
	#set_size(Vector2(702,40))
	#set_position(Vector2(6.852,675.652))
	pass # Replace with function body.

func updateHealth(healthChangeAmount):
	if value + healthChangeAmount < 0:
		value = 0
	else:
		value = int(value+healthChangeAmount) % maxHealth
	return value
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):

