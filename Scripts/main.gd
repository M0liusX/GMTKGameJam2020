extends Node
onready var timer = $screen_effect_timer
onready var background = $background
onready var screenToggle = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	print_tree_pretty()
	timer.start()

# Closing the game
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.scancode == KEY_TAB:
			get_tree().reload_current_scene()

# Uncomment for one-hit deaths
#func _on_player_ship_hit(player):
#	player.queue_free()
#	print("GAME OVER!")

func _on_UI_game_over(player):
	player.queue_free()
	print("GAME OVER!")

func _on_screen_effect_timer_timeout():
	if screenToggle:
		background.modulate = Color(1,1,1,1)
		screenToggle = false
	else:
		var gRNG = randf()
		var bRNG = randf()
		if abs(gRNG - bRNG) > 0.3:
			gRNG = 0.8
			bRNG = 0.9
		background.modulate = Color(0.5,gRNG,bRNG,1)
		screenToggle = true

	timer.start()
