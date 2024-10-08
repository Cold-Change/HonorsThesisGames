extends Node2D

@onready var movement_timer = $MovementTimer

var board : Array[String] = []
var board_width = 320
var board_height = 640

var tetromino = preload("res://Tetromino/tetromino.tscn")
const TETROMINO_SQUARES_SHEET = preload("res://Tetromino/Square Graphics/TetrominoSquares-Sheet.png")

func _ready():
	board.resize(240)
	board.fill('')
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
			kickOffWall(checkForWallKick())
		if Input.is_action_just_pressed("right") and checkPositionOnMove("right"):
			get_node("Tetromino").position.x += 32
		if Input.is_action_just_pressed("left") and checkPositionOnMove("left"):
			get_node("Tetromino").position.x -= 32

func checkPositionOnMove(direction):
	for square in get_node("Tetromino").get_children():
		if direction == "right":
			if floor(get_node("Tetromino").rotation) == 1:
				if get_node("Tetromino").position.x - square.position.y + 32 > board_width:
					return false
			elif floor(get_node("Tetromino").rotation) == 3:
				if get_node("Tetromino").position.x - square.position.x + 32 > board_width:
					return false
			elif floor(get_node("Tetromino").rotation) == 4:
				if get_node("Tetromino").position.x + square.position.y + 32 > board_width:
					return false
			else:
				if get_node("Tetromino").position.x + square.position.x + 32 > board_width:
					return false
		else:
			if floor(get_node("Tetromino").rotation) == 1:
				if get_node("Tetromino").position.x - square.position.y - 32 < 0:
					return false
			elif floor(get_node("Tetromino").rotation) == 3:
				if get_node("Tetromino").position.x - square.position.x - 32 < 0:
					return false
			elif floor(get_node("Tetromino").rotation) == 4:
				if get_node("Tetromino").position.x + square.position.y - 32 < 0:
					return false
			else:
				if get_node("Tetromino").position.x + square.position.x - 32 < 0:
					return false
	return true

func checkForWallKick():
	for square in get_node("Tetromino").get_children():
		if floor(get_node("Tetromino").rotation) == 1:
			if get_node("Tetromino").position.x - square.position.y > board_width:
				return 'left'
			elif get_node("Tetromino").position.x - square.position.y < 0:
				return 'right'
		elif floor(get_node("Tetromino").rotation) == 3:
			if get_node("Tetromino").position.x - square.position.x > board_width:
				return 'left'
			elif get_node("Tetromino").position.x - square.position.x < 0:
				return 'right'
		elif floor(get_node("Tetromino").rotation) == 4:
			if get_node("Tetromino").position.x + square.position.y > board_width:
				return 'left'
			elif get_node("Tetromino").position.x + square.position.y < 0:
				return 'right'
		else:
			if get_node("Tetromino").position.x + square.position.x > board_width:
				return 'left'
			elif get_node("Tetromino").position.x + square.position.x < 0:
				return 'right'
	return ''

func kickOffWall(direction):
	if direction == 'left':
		get_node("Tetromino").position.x -= 32
	elif direction == 'right':
		get_node("Tetromino").position.x += 32
	if direction != '':
		kickOffWall(checkForWallKick())

func _on_movement_timer_timeout():
	if has_node("Tetromino"):
		get_node("Tetromino").position.y += 32
