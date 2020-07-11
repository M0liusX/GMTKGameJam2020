extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
onready var gText = get_node("DialogueBox/TextBox")

func _ready():
	
	#gText = get_node("DialogueBox/TextBox")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = 600
func _process(_delta):
	if i == 400:
		gText.text = "fat booties."
	if i == 200:
		gText.text = "big dooties."
	if i == 0:
		gText.text = "DIIIEEEE!!!"
	i -= 1
#	pass
