extends KinematicBody2D


# Declare member variables here
export var MAX_SPEED = 10
export var ACCELERATION = 2
export var FRICTION = 2

var velocity = Vector2.ZERO
signal hit(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# NOTE: If we decide to use delta, remove underscore preceding it
func _process(_delta):
	
	# Processing player input
	var inputVector = Vector2.ZERO
	inputVector.x = 0
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
	inputVector = inputVector.normalized()
	
	# Physics for movement
	if inputVector:
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	var collisionCheck = move_and_collide(velocity)
	if collisionCheck:
		emit_signal("hit", self)
