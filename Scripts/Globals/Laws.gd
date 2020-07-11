extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Law {PLUS_ONE, STAR}
const LAW_COUNT = 2

var currentLaws = []
var futureLaws = []
export var totalLaws = 3

const queueSize = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(queueSize):
		futureLaws.append(randi() % LAW_COUNT)
	display()
	
func display():
	for law in futureLaws:
		print_law(law)
	for law in currentLaws:
		print_law(law)
	
func print_law(law):
	match law:
		Law.PLUS_ONE:
			print("Law One")
		Law.STAR:
			print("Star")
		_:
			print("Error")

func step():
	pass
