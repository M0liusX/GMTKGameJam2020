extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Rules = $Rules
onready var Credits = $Credits
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Scenes/prototype_2.tscn")
	if Input.is_action_just_pressed("ui_focus_next"):
		if Rules != null:
			Rules.visible = !Rules.visible
	if Input.is_action_just_pressed("ui_select"):
		if Credits != null:
			Credits.visible = !Credits.visible
