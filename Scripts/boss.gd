extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hit(boss)

enum State {IDLE,
			BUBBLEY,
			SUMMON,
}

# Visual Enums
enum Hairstyle {RANDOM = -1,
				LONG,
				HIME,
				BOB,
				TWINTAIL,
}
enum Haircolor {RANDOM = -1,
				BLONDE,
				BROWN,
				DARK,
				PINK,
				SILVER,
}
enum Costume {RANDOM = -1,
			HOODIE,
			PAJAMA,
			PE,
			UNIFORM1,
			UNIFORM2,
			SWIMSUIT,
			SUMMER,
			TOWEL,
			WINTER,
}
enum Accessory {RANDOM = -1,
				GLASSES_BLACK,
				CHOKER,
				GLASSES_CIRCLE,
				FLOWER,
				GLASSES_RED,
}

enum Expression {RANDOM = -1,
				ANGRY,
				ANNOYED,
				DELIGHTED,
				LAUGH,
				NORMAL,
				SAD,
				SHOCKED,
				SLEEPY,
				SMILE2,
				SMILE1,
				SMUG,
}
export var health = 100
var stepInterval = 10   # in s
var elapsedTime = 0
var actionTime = 0
var actionCounter = 0

var currentState = State.IDLE

const HAIRCOLORS = 5
onready var BackHair = $Sprite/BackHair
onready var FrontHair = $Sprite/FrontHair
onready var Accessories = $Sprite/Accessories
onready var Expressions = $Sprite/Expression
onready var Clothes = $Sprite/Clothes
onready var Blush = $Sprite/Blush

export(Hairstyle) var hairstyle = -1
export(Accessory) var accessory = -1
export(Costume) var clothes = -1
export(Haircolor) var haircolor = -1 
export(Expression) var expression = -1

# ATTACKS
const BUBBLE = preload("res://Objects/BossAttacks/Bubble.tscn")
const BASIC_ENEMY = preload("res://Objects/BasicEnemy/BasicEnemyWithPath.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	show_character()
	
func randomize_it(list, color = -1, set = -1):
	var amount = list.size()
	var chosen = set
	if chosen == -1:
		chosen = randi() % amount
		
	for item in list:
		item.hide()
	list[chosen].show()
	
	if color != -1:
		for item in list[chosen].get_children():
			item.hide()
		list[chosen].get_children()[color].show()
		
	return chosen
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		show_character()
		return
		
	elapsedTime += delta
	actionTime += delta
	process_laws()
	state_machine()
	
# Checks elapsed time and adds a new law`
func process_laws():
	if elapsedTime > stepInterval:
		elapsedTime = 0
		var newLaw = Laws.step(get_potential_laws())
		

func do_idle():
	show_character()
	if actionTime > 3:
		actionTime = 0
		expression = Expression.NORMAL
		change_state(randi()%2 + 1)

func do_summon():
	show_character()
	if actionTime > 2:
		actionTime = 0
		actionCounter += 1
		expression = Expression.LAUGH
		# Make Instance
		var Enemy = BASIC_ENEMY.instance()
		var position = Vector2(-1800, -800 + (randi()%2)*400)
		Enemy.set_global_position(position)
		self.add_child(Enemy)
	
	if actionCounter > 1:
		change_state(State.IDLE)
		
func do_bubbley():
	show_character()
	if actionTime > 0.5:
		expression = Expression.ANGRY
		actionTime = actionCounter*0.022
		 #Make instance
		var BubbleInstance = BUBBLE.instance()
		var position = Vector2(-100 , (randi() % 600) - 300)
		BubbleInstance.set_position(position)
		var scaling = randf()*2
		BubbleInstance.set_scale(Vector2(1+scaling, 1+scaling))
		self.add_child(BubbleInstance)
		
		var currentLaws = [] + Laws.currentLaws
		while Laws.Law.DOUBLE_BULLETS in currentLaws:
			var BubbleInstance2 = BUBBLE.instance()
			position = Vector2(position.x, position.y + 10)
			BubbleInstance2.set_position(position)
			BubbleInstance2.set_scale(Vector2(1+scaling, 1+scaling))
			self.add_child(BubbleInstance2)
			currentLaws.erase(Laws.Law.DOUBLE_BULLETS)
			
		actionCounter+=1

	if actionCounter > 10:
		change_state(State.IDLE)
	
func get_potential_laws():
	match currentState:
		State.BUBBLEY:
			return [Laws.Law.DOUBLE_BULLETS]
		_:
			return [Laws.Law.DOUBLE_BULLETS]

func change_state(newState):
	actionCounter = 0
	actionTime = 0
	currentState = newState
	
func state_machine():
	match currentState:
		State.BUBBLEY:
			do_bubbley()
		State.IDLE:
			do_idle()
		State.SUMMON:
			do_summon()
		_:
			do_idle()
			
func got_hit(damage):
	health -= damage
	actionTime = 0
	expression = Expression.SHOCKED
	show_character()
	print("boss health: " + str(health))
	emit_signal("hit", self)
	
	if health <= 0:
		print("YOU WIN")
		queue_free()
	
func show_character():
	randomize()
	if haircolor == -1:
		haircolor = randi() % HAIRCOLORS
	var chosenstyle = randomize_it(BackHair.get_children(), haircolor, hairstyle)
	hairstyle = randomize_it(FrontHair.get_children(), haircolor, chosenstyle)
	accessory = randomize_it(Accessories.get_children(), -1, accessory)
	expression = randomize_it(Expressions.get_children(), -1, expression)
	clothes = randomize_it(Clothes.get_children(), -1, clothes)
