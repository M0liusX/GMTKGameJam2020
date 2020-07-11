extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Image = $Sprite

const possible = [0,1,2,3,4,5,6, 16,17,18,19,20,21,22]

var direction = Vector2(-10,0)
export var speed = 7
export var frequency = 5.0
export var amplitude = 12.0

var elapsedTime = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var chosen = possible[randi() % possible.size()]
	Image.set_frame(chosen) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsedTime += delta
	direction.y = sin(elapsedTime*frequency)*amplitude
	move_and_collide(direction*delta*speed)
	if get_global_position().x < -10:
		queue_free()
