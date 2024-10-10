extends Node2D

@onready var movement_timer = $MovementTimer

@onready var board = $Board
var board_width = 320
var board_height = 640

var tetromino = preload("res://Tetromino/tetromino.tscn")

func _ready():
	movement_timer.start()
	createNewTetromino()

func _physics_process(delta):
	if has_node("Tetromino"):
		manageTetrominoMovement()

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

func manageTetrominoMovement():
	if Input.is_action_just_pressed("up"):
		if floor(get_node("Tetromino").rotation) == 4:
			get_node("Tetromino").rotation = 0
			for square in get_node("Tetromino").get_children():
				square.rotation = 0
		else:
			get_node("Tetromino").rotation += PI/2
			for square in get_node("Tetromino").get_children():
				square.rotation -= PI/2
		if !board.checkForOverlap(convertTetrominoToArray()):
			if floor(get_node("Tetromino").rotation) == 0:
				get_node("Tetromino").rotation = (3*PI)/2
				for square in get_node("Tetromino").get_children():
					square.rotation = -(3*PI)/2
			else:
				get_node("Tetromino").rotation -= PI/2
				for square in get_node("Tetromino").get_children():
					square.rotation += PI/2
		kickOffWall(checkForWallKick())
	if Input.is_action_just_pressed("right") and checkPositionOnMove("right"):
		get_node("Tetromino").position.x += 32
		if !board.checkForOverlap(convertTetrominoToArray()):
			get_node("Tetromino").position.x -= 32
	if Input.is_action_just_pressed("left") and checkPositionOnMove("left"):
		get_node("Tetromino").position.x -= 32
		if !board.checkForOverlap(convertTetrominoToArray()):
			get_node("Tetromino").position.x += 32
	if Input.is_action_just_pressed("down"):
		shiftTetrominoDown()
		movement_timer.start()
	if Input.is_action_just_pressed("accept"):
		if board.checkForOverlap(convertTetrominoToArray()):
			board.lockTetrominoToBoard(convertTetrominoToArray(),get_node("Tetromino").shape)
			createNewTetromino()

func shiftTetrominoDown():
	if has_node("Tetromino"):
		var tetromino_can_move = true
		var tetromino_locked = false
		for i in convertTetrominoToArray():
			var last_row = [230,231,232,233,234,235,236,237,238,239]
			if last_row.has(int(i)) and !tetromino_locked:
				board.lockTetrominoToBoard(convertTetrominoToArray(),get_node("Tetromino").shape)
				createNewTetromino()
				tetromino_can_move = false
				tetromino_locked = true
		if tetromino_can_move:
			get_node("Tetromino").position.y += 32
			if !board.checkForOverlap(convertTetrominoToArray()):
				get_node("Tetromino").position.y -= 32
				board.lockTetrominoToBoard(convertTetrominoToArray(),get_node("Tetromino").shape)
				createNewTetromino()

func createNewTetromino():
	if has_node("Tetromino"):
		get_node("Tetromino").name = "OldTetromino"
		get_node("OldTetromino").queue_free()
	var new_tetromino = tetromino.instantiate()
	add_child(new_tetromino)
	new_tetromino.name = "Tetromino"
	new_tetromino.position = Vector2(board_width/2,32)
	#new_tetromino.initTetromino("I")
	new_tetromino.initTetromino(Globals.Tetromino.keys()[randi() % Globals.Tetromino.size()])
	movement_timer.start()

func _on_movement_timer_timeout():
	shiftTetrominoDown()

func convertTetrominoToArray():
	if has_node("Tetromino"):
		var termino_position = get_node("Tetromino").position / 32
		var array_to_return = []
		for square in get_node("Tetromino").get_children():
			var square_position : Vector2
			if floor(get_node("Tetromino").rotation) == 1:
				square_position = termino_position - ceil(Vector2(square.position.y,-square.position.x) / 32)
			elif floor(get_node("Tetromino").rotation) == 3:
				square_position = termino_position - ceil(square.position / 32)
			elif floor(get_node("Tetromino").rotation) == 4:
				square_position = termino_position + floor(Vector2(square.position.y,-square.position.x) / 32)
			else:
				square_position = termino_position + floor(square.position / 32)
			array_to_return.append(square_position.x + square_position.y*10 + 40)
		return array_to_return
