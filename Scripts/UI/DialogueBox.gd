extends NinePatchRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextBox.text = "Hi how are ya?"
	pass # Replace with function body.

func getRandomText(i):
	# get a num between 1 and 5
	match i%5: #randi()%5+1:
		1: return "Uhm like.......what?"
		2: return "I said stop it!!!"
		3: return "That didn't even hurt..."
		4: return "I'LL BLOW YOU UP >:|"
		5: return "explosive.png"
		_: return "Fufufufufu"

var i = 0
func updateDialogue(health):
	var textBox = $TextBox
	if health == 0:
		textBox.text = "WWWAAAAAAAAHHHHHH"
	else:
		textBox.text = getRandomText(i)
	i += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
