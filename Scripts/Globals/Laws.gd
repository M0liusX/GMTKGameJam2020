extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Law {REVERSE_CONTROLS,   # REVERSES (UP/DOWN) & (LEFT/RIGHT) 
		  MOUSE_CONTROLS,     # CHANGES CONTROL SCHEME 
		  DOUBLE_BULLETS,     # All Bullets Doubles
		  INVINCIBILITY,      # Gives Player Invicibility  
		  LOVE,               # Three Love and you win the secret ending!
}
		
const LAW_COUNT = 4   # Update whenever you add a new law (Subtract Special Laws)

var currentLaws = []
var futureLaws = []
export var totalLaws = 3

const queueSize = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(queueSize):
		futureLaws.push_front(randi() % LAW_COUNT)
	display()
	
func display():
	print("--- Future Laws ---")
	for law in futureLaws:
		print_law(law)
	print("--- Current Laws ---")
	for law in currentLaws:
		print_law(law)
	
func print_law(law):
	match law:
		Law.REVERSE_CONTROLS:
			print("REVERSE_CONTROLS")
		Law.MOUSE_CONTROLS:
			print("MOUSE_CONTROLS")
		Law.DOUBLE_BULLETS:
			print("DOUBLE_BULLETS")
		_:
			print("Error")

# Takes array of possible new laws
func step(available = range(LAW_COUNT)):
	if currentLaws.size() == totalLaws:
		currentLaws.pop_back()
	var newLaw = futureLaws.pop_back()
	currentLaws.push_front(newLaw)
	futureLaws.push_front(available[randi() % available.size()])
	display()
	
	return newLaw
