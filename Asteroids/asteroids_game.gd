extends Node2D

@onready var player = $Player
var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")


func _process(delta):
	if player.position.x < 0:
		player.position.x = window_width
	elif player.position.x > window_width:
		player.position.x = 0
	if player.position.y < 0:
		player.position.y = window_height
	elif player.position.y > window_height:
		player.position.y = 0
