extends Node2D

@onready var movement_timer = $MovementTimer
@onready var cleanup_timer = $CleanupTimer

@onready var start_ui = $Start
@onready var game_over_ui = $GameOver
@onready var score_label_1 = $GameOver/Panel/VBoxContainer/Score
@onready var high_score_label_1 = $GameOver/Panel/VBoxContainer/HighScore
@onready var running_ui = $Running
@onready var hgih_score_label_2 = $Running/VBoxContainer/HgihScore
@onready var score_label_2 = $Running/VBoxContainer/Score

@onready var board = $Board
var board_width = 320
var board_height = 640

@onready var cleanup = $Cleanup

var tetromino = preload("res://Tetromino/tetromino.tscn")

var score = 0
var state = "Start"

func _ready():
	board.rowCleared.connect(initCleanup)
	board.gameOver.connect(gameOver)
	board.increaseScore.connect(increaseScore)

func _physics_process(delta):
	if state == "Start" and Input.is_action_just_pressed("accept"):
		startGame()
	if state == "GameOver" and Input.is_action_just_pressed("accept"):
		resetGame()
	if state == "Running" and has_node("Tetromino"):
		manageTetrominoMovement()
		
func startGame():
	movement_timer.start()
	createNewTetromino()
	state = "Running"
	hgih_score_label_2.text = "High Score: " + str(Globals.high_score)
	score_label_2.text = "Score: " + str(score)
	start_ui.visible = false
	running_ui.visible = true

func gameOver():
	state = "GameOver"
	movement_timer.stop()
	if score > Globals.high_score:
		Globals.high_score = score
	score_label_1.text = "Your score is " + str(score)
	high_score_label_1.text = "The high score is " + str(Globals.high_score)
	running_ui.visible = false
	game_over_ui.visible = true

func resetGame():
	state = "Start"
	board.clearBoard()
	get_node("Tetromino").queue_free()
	score = 0
	game_over_ui.visible = false
	start_ui.visible = true

func increaseScore(amount):
	score += amount
	score_label_2.text = "Score: " + str(score)
	if score > Globals.high_score:
		Globals.high_score = score
		hgih_score_label_2.text = "High Score: " + str(Globals.high_score)

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

#Checks position and rotation of tetromino and returns a direction if the tetromino goes beyond the scope of the board
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

#Shifts the tetromino left or right according to the direction provided
#Recurs itself if a direction is provided
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
	if Input.is_action_just_pressed("drop"):
		dropTetromino()

#Returns true if tetromino can still shift down, false if tetromino cannot shift down
func shiftTetrominoDown():
	if has_node("Tetromino") and state == "Running":
		var tetromino_can_move = true
		var tetromino_locked = false
		for i in convertTetrominoToArray():
			var last_row = [230,231,232,233,234,235,236,237,238,239]
			if last_row.has(int(i)) and !tetromino_locked:
				board.lockTetrominoToBoard(convertTetrominoToArray(),get_node("Tetromino").shape)
				board.checkForGameOver()
				createNewTetromino()
				tetromino_can_move = false
				tetromino_locked = true
				return false
		if tetromino_can_move:
			get_node("Tetromino").position.y += 32
			if !board.checkForOverlap(convertTetrominoToArray()):
				get_node("Tetromino").position.y -= 32
				board.lockTetrominoToBoard(convertTetrominoToArray(),get_node("Tetromino").shape)
				board.checkForGameOver()
				createNewTetromino()
				return false
	return true

#Recurs shiftTetrominoDown() to bring the tetromino to its lowest possible position
func dropTetromino():
	var can_shift_down = true
	while can_shift_down:
		can_shift_down = shiftTetrominoDown()

#Frees current tetromino and creates a new tetromino
func createNewTetromino():
	if has_node("Tetromino"):
		get_node("Tetromino").name = "OldTetromino"
		get_node("OldTetromino").reparent(cleanup)
		cleanup_timer.start()
	var new_tetromino = tetromino.instantiate()
	add_child(new_tetromino)
	new_tetromino.name = "Tetromino"
	new_tetromino.position = Vector2(board_width/2,32)
	new_tetromino.initTetromino(Globals.Tetromino.keys()[randi() % Globals.Tetromino.size()])
	movement_timer.start()

#Converts tetromino into an array of 4 integers corresponding to locations in the board array
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

func initCleanup():
	for child in cleanup.get_children():
		child.visible = false
		child.free()

func _on_movement_timer_timeout():
	shiftTetrominoDown()

func _on_cleanup_timer_timeout():
	initCleanup()
