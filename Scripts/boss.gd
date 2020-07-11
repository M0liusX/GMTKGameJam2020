extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum State {IDLE,
}

export var health = 100
var stepInterval = 10   # in s
var elapsedTime = 0

var currentState = State.IDLE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsedTime += delta
	process_laws()
	state_machine()
	
# Checks elapsed time and adds a new law`
func process_laws():
	if elapsedTime > stepInterval:
		elapsedTime = 0
		Laws.step(get_potential_laws())

func get_potential_laws():
	match currentState:
		_:
			return range(Laws.LAW_COUNT)

func state_machine():
	match currentState:
		_:
			return

func got_hit(damage):
	health -= damage
	
