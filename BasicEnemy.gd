extends KinematicBody2D

onready var bullet_scene = preload("res://Objects/BasicEnemy/Bullet.tscn")
onready var path_follow = get_parent()
export var speed 		   = 250
export var BulletFrequency = 1.0

var time = 0

func MovementLoop(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	

func ShootBullet():
	print("BasicEnemy: ShootBullet")
	var bullet = bullet_scene.instance()
	bullet.set_position(Vector2(0,0))
	add_child(bullet)
	bullet.set_as_toplevel(true)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MovementLoop(delta)
	
	if (time >= BulletFrequency):
		ShootBullet()
		time = 0
		
	time += delta
	
func got_hit(damage = 0):
	queue_free()
