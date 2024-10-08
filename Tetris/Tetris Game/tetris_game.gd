extends Node2D

@onready var movement_timer = $MovementTimer

var board_width = 320
var board_height = 640

var tetromino = preload("res://Tetromino/tetromino.tscn")

func _ready():
	movement_timer.start()

func _physics_process(delta):
	if Input.is_action_just_pressed("accept"):
		var new_tetromino = tetromino.instantiate()
		add_child(new_tetromino)
		new_tetromino.position = Vector2(board_width/2,32)
		new_tetromino.initTetromino(Globals.Tetromino.keys()[randi() % Globals.Tetromino.size()])
		movement_timer.start()
	if has_node("Tetromino"):
		if Input.is_action_just_pressed("up"):
			if floor(get_node("Tetromino").rotation) == 4:
				get_node("Tetromino").rotation = 0
				for square in get_node("Tetromino").get_children():
					square.rotation = 0
			else:
				get_node("Tetromino").rotation += PI/2
				for square in get_node("Tetromino").get_children():
					square.rotation -= PI/2
		if Input.is_action_just_pressed("right") and checkPositionOnMove("right"):
			get_node("Tetromino").position.x += 32
		if Input.is_action_just_pressed("left") and checkPositionOnMove("left"):
			get_node("Tetromino").position.x -= 32

func checkPositionOnMove(direction):
	for square in get_node("Tetromino").get_children():
		print(get_node("Tetromino").position.x + square.position.x)
		print(get_node("Tetromino").rotation)
		if direction == "right":
			if floor(get_node("Tetromino").rotation) == 1:
				if get_node("Tetromino").position.x - square.position.y + 32 > board_width:
					return false
			elif floor(get_node("Tetromino").rotation) == 4:
				if get_node("Tetromino").position.x + square.position.y + 32 > board_width:
					return false
			elif floor(get_node("Tetromino").rotation) == 3:
				if get_node("Tetromino").position.x + square.position.x > board_width:
					return false
			else:
				if get_node("Tetromino").position.x + square.position.x + 32 > board_width:
					return false
		else:
			if get_node("Tetromino").position.x + square.position.x - 32 < 0:
				return false
	return true

func _on_movement_timer_timeout():
	if has_node("Tetromino"):
		get_node("Tetromino").position.y += 32
