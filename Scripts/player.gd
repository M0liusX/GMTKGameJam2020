extends KinematicBody2D


# Declare member variables here
onready var bullet = preload("res://Objects/bullet.tscn")
onready var activeBullet

export var MAX_SPEED = 10
export var ACCELERATION = 2
export var FRICTION = 2
var movementRNG = 0
var flashing = false

enum {SHIP, BULLET}
var Mode = SHIP
var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

var velocity = Vector2.ZERO
var shipVelocity = Vector2.ZERO
signal hit(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# NOTE: If we decide to use delta, remove underscore preceding it
func _process(_delta):
	
	# Effect for hitting the player
	if flashing:
		modulate = Color(1,1,1, 0.1)

	# Generate a random direction
	movementRNG = randi() % 3
	
	var inputVector = Vector2.ZERO
	# Restrict movement to 1D for bullet mode
	if Mode == BULLET:
		inputVector.x = 1
	else:
		inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
	inputVector = inputVector.normalized()
	
	# Physics for movement
	if inputVector:
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	# Collision check
	if Mode == SHIP:
		var collisionCheck = move_and_collide(velocity)
		checkCollisions(collisionCheck, null)
	elif Mode == BULLET:
#		var shipCheck = move_and_collide(Vector2.ZERO,true,true,true)
		shipVelocity = shipVelocity.move_toward(directions[movementRNG] * MAX_SPEED, ACCELERATION)
		var shipCheck = move_and_collide(shipVelocity)
		var bulletCheck = activeBullet.move_and_collide(velocity)
		checkCollisions(shipCheck, bulletCheck)


	# Check to see if player fired a bullet and switch mode
	if Input.is_action_just_pressed("ui_select") and Mode == SHIP:
		activeBullet = bullet.instance()
		add_child(activeBullet)
		activeBullet.set_as_toplevel(true)
		activeBullet.set_position(self.get_position())
		Mode = BULLET
		# Random Ship Movement
		movementRNG = randi() % 3

func checkCollisions(shipCheck, bulletCheck):
		if shipCheck:
			if shipCheck.collider.is_in_group("enemy"):
				print("hit")
				# Layers 4, 2^3
				_set_layers(8)
				emit_signal("hit", self)
				$Timer.start()
				flashing = true
		if bulletCheck:
			# @TODO: Double-check bullet on bullet collision
			if bulletCheck.collider.is_in_group("enemy") and !bulletCheck.collider.is_in_group("bullet"):
				print("enemy hit")
				bulletCheck.collider.got_hit(10)
			activeBullet.queue_free()
			Mode = SHIP

func _on_Timer_timeout():
	# Layers 1, 2, and 4, i.e. 2^0 + 2^1 + 2^3 = 11
	_set_layers(11)
	modulate = Color(1,1,1,1)
	flashing = false
