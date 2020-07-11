tool
extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum State {IDLE,
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

export var health = 100
var stepInterval = 10   # in s
var elapsedTime = 0

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
var expression = -1
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
	elapsedTime += delta
	process_laws()
	state_machine()
	if Engine.editor_hint:
		show_character()
	
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
	
func show_character():
	randomize()
	if haircolor == -1:
		haircolor = randi() % HAIRCOLORS
	var chosenstyle = randomize_it(BackHair.get_children(), haircolor, hairstyle)
	randomize_it(FrontHair.get_children(), haircolor, chosenstyle)
	randomize_it(Accessories.get_children(), -1, accessory)
	expression = randomize_it(Expressions.get_children(), -1, expression)
	randomize_it(Clothes.get_children(), -1, clothes)
