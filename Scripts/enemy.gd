extends KinematicBody2D


# Declare member variables here
export var MAX_SPEED = 10
var MAX_VELOCITY = Vector2(-MAX_SPEED, 0)
export var ACCELERATION = 2
export var FRICTION = 2

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Processing player input
	
	# Physics for movement
	velocity = velocity.move_toward(MAX_VELOCITY, ACCELERATION)
	move_and_collide(velocity)

func got_hit(damage = 0):
	queue_free()
