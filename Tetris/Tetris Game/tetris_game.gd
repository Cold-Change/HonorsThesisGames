extends Node2D

@onready var movement_timer = $Timers/MovementTimer
@onready var cleanup_timer = $Timers/CleanupTimer
@onready var slide_timer = $Timers/SlideTimer
@onready var slide_buffer_timer = $Timers/SlideBufferTimer

@onready var start_ui = $Start
@onready var game_over_ui = $GameOver
@onready var score_label_1 = $GameOver/Panel/VBoxContainer/Score
@onready var high_score_label_1 = $GameOver/Panel/VBoxContainer/HighScore
@onready var running_ui = $Running
@onready var hgih_score_label_2 = $Running/VBoxContainer/HgihScore
@onready var score_label_2 = $Running/VBoxContainer/Score
@onready var level_label = $Running/VBoxContainer/Level
@onready var paused_ui = $Paused

@onready var board = $Board
var board_width = 320
var board_height = 640

@onready var cleanup = $Cleanup

@onready var display_tetromino = $DisplayTetromino
@onready var hold_tetromino = $HoldTetromino

var can_hold_tetromino = true

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
		if Input.is_action_just_pressed("pause"):
			get_tree().paused = !get_tree().paused
			paused_ui.visible = !paused_ui.visible
		if !get_tree().paused:
			manageTetrominoMovement()
			if Input.is_action_just_pressed("hold") and can_hold_tetromino:
				addTetrominoToHold()
		
func startGame():
	movement_timer.wait_time = 1
	Globals.level = 1
	level_label.text = "Level: " + str(Globals.level)
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
	if has_node("Tetromino"):
		get_node("Tetromino").queue_free()
	if display_tetromino.has_node("DisplayTetromino"):
		display_tetromino.get_node("DisplayTetromino").queue_free()
	if hold_tetromino.has_node("HoldTetromino"):
		hold_tetromino.get_node("HoldTetromino").queue_free()
	score = 0
	Globals.level = 1
	game_over_ui.visible = false
	start_ui.visible = true

func increaseScore(amount):
	score += amount
	score_label_2.text = "Score: " + str(score)
	if score > Globals.high_score:
		Globals.high_score = score
		hgih_score_label_2.text = "High Score: " + str(Globals.high_score)
	if score / 1000 == Globals.level:
		levelUp()

func levelUp():
	Globals.level += 1
	if Globals.level <= 11:
		movement_timer.wait_time = 1 - Globals.level * 0.05
	elif movement_timer.wait_time > 0.05:
		movement_timer.wait_time = 1 - Globals.level * 0.05 - floor((Globals.level - 11)/2) * 0.05
	else:
		movement_timer.wait_time = 0.05
	level_label.text = "Level: " + str(Globals.level)
	print(movement_timer.wait_time)

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
		else:
			slide_buffer_timer.start()
	if Input.is_action_just_pressed("left") and checkPositionOnMove("left"):
		get_node("Tetromino").position.x -= 32
		if !board.checkForOverlap(convertTetrominoToArray()):
			get_node("Tetromino").position.x += 32
		else:
			slide_buffer_timer.start()
	if Input.is_action_just_pressed("down"):
		if shiftTetrominoDown():
			increaseScore(1)
		movement_timer.start()
		slide_buffer_timer.start()
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
				createNewTetromino()
				tetromino_can_move = false
				tetromino_locked = true
				return false
		if tetromino_can_move:
			get_node("Tetromino").position.y += 32
			if !board.checkForOverlap(convertTetrominoToArray()):
				get_node("Tetromino").position.y -= 32
				board.lockTetrominoToBoard(convertTetrominoToArray(),get_node("Tetromino").shape)
				createNewTetromino()
				return false
	return true

#Recurs shiftTetrominoDown() to bring the tetromino to its lowest possible position
func dropTetromino():
	var can_shift_down = true
	var times_shifted = 0
	while can_shift_down:
		can_shift_down = shiftTetrominoDown()
		if can_shift_down:
			times_shifted += 2
	increaseScore(times_shifted)

#Frees current tetromino and creates a new tetromino
func createNewTetromino(tetromino_type = ''):
	if has_node("Tetromino"):
		get_node("Tetromino").name = "OldTetromino"
		get_node("OldTetromino").reparent(cleanup)
		cleanup_timer.start()
	var new_tetromino = tetromino.instantiate()
	add_child(new_tetromino)
	new_tetromino.name = "Tetromino"
	new_tetromino.position = Vector2(board_width/2,32)
	if tetromino_type:
		new_tetromino.initTetromino(tetromino_type)
	elif display_tetromino.has_node("DisplayTetromino"):
		new_tetromino.initTetromino(display_tetromino.get_node("DisplayTetromino").shape)
		addTetrominoToDisplay()
	else:
		new_tetromino.initTetromino(Globals.Tetromino.keys()[randi() % Globals.Tetromino.size()])
		addTetrominoToDisplay()
	movement_timer.start()
	can_hold_tetromino = true

#Frees current display tetromino and creates a new display tetromino
func addTetrominoToDisplay():
	if display_tetromino.has_node("DisplayTetromino"):
		get_node("DisplayTetromino").get_node("DisplayTetromino").free()
	var new_tetromino = tetromino.instantiate()
	display_tetromino.add_child(new_tetromino)
	new_tetromino.name = "DisplayTetromino"
	new_tetromino.scale = Vector2(.5,.5)
	new_tetromino.initTetromino(Globals.Tetromino.keys()[randi() % Globals.Tetromino.size()])

#Frees current hold tetromino and creates a new hold tetromino
func addTetrominoToHold():
	var previously_held_tetromino = ''
	if hold_tetromino.has_node("HoldTetromino"):
		previously_held_tetromino = hold_tetromino.get_node("HoldTetromino").shape
		get_node("HoldTetromino").get_node("HoldTetromino").free()
	var new_tetromino = tetromino.instantiate()
	hold_tetromino.add_child(new_tetromino)
	new_tetromino.name = "HoldTetromino"
	new_tetromino.scale = Vector2(.5,.5)
	new_tetromino.initTetromino(get_node("Tetromino").shape)
	get_node("Tetromino").free()
	if previously_held_tetromino:
		createNewTetromino(previously_held_tetromino)
	else:
		createNewTetromino()
	can_hold_tetromino = false

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
		child.free()

func _on_movement_timer_timeout():
	if !get_tree().paused:
		shiftTetrominoDown()

func _on_cleanup_timer_timeout():
	if !get_tree().paused:
		initCleanup()

func _on_slide_timer_timeout():
	if !slide_buffer_timer.time_left and !get_tree().paused:
		if Input.is_action_pressed("right") and checkPositionOnMove("right"):
			get_node("Tetromino").position.x += 32
			if !board.checkForOverlap(convertTetrominoToArray()):
				get_node("Tetromino").position.x -= 32
		if Input.is_action_pressed("left") and checkPositionOnMove("left"):
			get_node("Tetromino").position.x -= 32
			if !board.checkForOverlap(convertTetrominoToArray()):
				get_node("Tetromino").position.x += 32
		if Input.is_action_pressed("down"):
			if shiftTetrominoDown():
				increaseScore(1)
			movement_timer.start()
