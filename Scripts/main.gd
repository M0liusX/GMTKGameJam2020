extends Node


# Declare member variables here.


# Called when the node enters the scene tree for the first time.
func _ready():
#	print_tree_pretty()
	pass

# Closing the game
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

# Uncomment for one-hit deaths
#func _on_player_ship_hit(player):
#	player.queue_free()
#	print("GAME OVER!")

func _on_UI_game_over(player):
	player.queue_free()
	print("GAME OVER!")
