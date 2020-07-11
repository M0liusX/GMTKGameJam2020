extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 20
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = -speed # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(velocity)
