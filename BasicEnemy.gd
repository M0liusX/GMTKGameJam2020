extends KinematicBody2D

onready var bullet_scene = preload("res://Objects/BasicEnemy/Bullet.tscn")
onready var path_follow = get_parent()
export var speed 		   = 250
export var BulletFrequency = 1.0

var time = 0

func MovementLoop(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	

func ShootBullet():
	var bullet = bullet_scene.instance()
	var iposition = Vector2(0,0)
	bullet.set_position(iposition)
	add_child(bullet)
	bullet.set_as_toplevel(true)
	
	var currentLaws = [] + Laws.currentLaws
	while Laws.Law.DOUBLE_BULLETS in currentLaws:
		var bullet2 = bullet_scene.instance()
		iposition = Vector2(iposition.x, iposition.y + 5)
		bullet2.set_position(iposition)
		add_child(bullet2)
		bullet.set_as_toplevel(true)
		currentLaws.erase(Laws.Law.DOUBLE_BULLETS)


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
	if global_position.x <= -10:
		got_hit()
		
func got_hit(damage = 0):
	queue_free()
