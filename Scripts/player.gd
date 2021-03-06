extends KinematicBody2D


# Declare member variables here
onready var bullet = preload("res://Objects/bullet2.tscn")
onready var bullet2 = preload("res://Objects/bullet3.tscn")
onready var bullet3 = preload("res://Objects/bullet4.tscn")
onready var bullet4 = preload("res://Objects/bullet5.tscn")
onready var bulletSelection = [bullet, bullet2, bullet3, bullet4]
onready var timer = $Timer

const BULLET_COUNT = 4
export var MAX_SPEED = 10
export var ACCELERATION = 2
export var FRICTION = 2
var movementRNG = 0
var flashing = false
var activeBullets = []
var nextBullet

enum {SHIP, BULLET}
var Mode = SHIP
var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

var heart = false
var velocity = Vector2.ZERO
var shipVelocity = Vector2.ZERO
var mouseVelocity = Vector2.ZERO
signal hit(player)
signal pass_bullet(bullet, heart)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	nextBullet = bulletSelection[randi()%BULLET_COUNT]
	if nextBullet.instance().is_in_group("heart"):
		heart = true
	else:
		heart = false
	emit_signal("pass_bullet", nextBullet.instance().get_child(1).texture, heart)

func _input(event):
	if event is InputEventMouseMotion:
		mouseVelocity = event.relative
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
# NOTE: If we decide to use delta, remove underscore preceding it
func _process(_delta):
	
	# Effect for hitting the player
	if flashing:
		modulate = Color(1,1,1, 0.5)

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
	
	var currentLaws = [] + Laws.currentLaws
	while Laws.Law.REVERSE_CONTROLS in currentLaws and not(Laws.Law.MOUSE_CONTROLS in Laws.currentLaws) and Mode == SHIP:
		currentLaws.erase(Laws.Law.REVERSE_CONTROLS)
		inputVector =-inputVector
		
	if Laws.Law.MOUSE_CONTROLS in Laws.currentLaws:
		#velocity = mouseVelocity.move_toward(mouseVelocity * MAX_SPEED, ACCELERATION)
		velocity = (get_global_mouse_position() - global_position) * 0.1
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
		for activeBullet in activeBullets:
			if Laws.Law.MOUSE_CONTROLS in Laws.currentLaws:
				velocity.y = (get_global_mouse_position().y - activeBullet.global_position.y) * 0.1
				velocity.x = 10
	#		var shipCheck = move_and_collide(Vector2.ZERO,true,true,true)
			shipVelocity = shipVelocity.move_toward(directions[movementRNG] * MAX_SPEED, ACCELERATION)
			var shipCheck = move_and_collide(shipVelocity)
			var bulletCheck = activeBullet.move_and_collide(velocity)
			checkCollisions(shipCheck, bulletCheck, activeBullet)


	# Check to see if player fired a bullet and switch mode
	if Input.is_action_just_pressed("ui_select") and Mode == SHIP:
		var activeBullet = nextBullet.instance()
		nextBullet = bulletSelection[randi() % BULLET_COUNT]
		if nextBullet.instance().is_in_group("heart"):
			heart = true
		else:
			heart = false
		emit_signal("pass_bullet", nextBullet.instance().get_child(1).texture, heart)
		add_child(activeBullet)
		activeBullet.set_as_toplevel(true)
		var iposition = self.get_position()
		iposition.x += 20
		activeBullet.set_position(iposition)
		Mode = BULLET
		activeBullets.append(activeBullet)
		# Random Ship Movement
		movementRNG = randi() % 3
		
		currentLaws = [] + Laws.currentLaws
		#for i in range(1):
		while Laws.Law.DOUBLE_BULLETS in currentLaws:
			var activeBullet2 = bullet.instance()
			add_child(activeBullet2)
			activeBullet2.set_as_toplevel(true)
			iposition = Vector2(iposition.x, iposition.y + 10)
			activeBullet2.set_position(iposition)
			activeBullets.append(activeBullet2)
			currentLaws.erase(Laws.Law.DOUBLE_BULLETS)
	
	# Check if active bullets leave the screen
	for activeBullet in activeBullets:
		if activeBullet.global_position.x > 1400 or activeBullet.global_position.x < 0 :
			activeBullets.erase(activeBullet)
			activeBullet.queue_free()
			if activeBullets.size() == 0:
				Mode = SHIP
			
func checkCollisions(shipCheck, bulletCheck, activeBullet = null):
		if shipCheck:
			if shipCheck.collider.is_in_group("enemy"):
				# Switching layers here creates invincibility Layers 4, 2^3 = 8
				_set_layers(8)
				if !(Laws.Law.INVINCIBILITY in Laws.currentLaws):
					emit_signal("hit", self)
					timer.start()
					flashing = true
		if bulletCheck:
			# @TODO: Double-check bullet on bullet collision
			if bulletCheck.collider.is_in_group("wall"):
				activeBullets.erase(activeBullet)
				activeBullet.queue_free()
			var bulletString = "bullet"
			if bulletCheck.collider.is_in_group("enemy") and !(bulletString in bulletCheck.collider.get_name()):
				print("enemy hit")
				if activeBullet.is_in_group("heart"):
					bulletCheck.collider.got_hit(-2)
				else:
					bulletCheck.collider.got_hit(2)
				activeBullets.erase(activeBullet)
				activeBullet.queue_free()
			if activeBullets.size() == 0:
				Mode = SHIP

func _on_Timer_timeout():
	# Layers 1, 2, and 4, i.e. 2^0 + 2^1 + 2^3 = 11
	_set_layers(11)
	modulate = Color(1,1,1,1)
	flashing = false
