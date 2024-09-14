extends Node2D

@onready var ball = $Ball

func _process(delta):
	if ball.position.x < 0 or ball.position.x > 1280:
		get_tree().change_scene_to_file("res://pong_game.tscn")
