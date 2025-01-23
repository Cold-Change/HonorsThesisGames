extends Node

var board_array : Array[String] = []

signal rowCleared
signal increaseScore(amount)
signal gameOver

func _ready():
	board_array.resize(240)
	board_array.fill('')

#Inputs tetromino type into board array according to the array of positions provided
func lockTetrominoToBoard(tetromino_array,tetromino_type):
	for i in tetromino_array:
		if board_array[i]:
			gameOver.emit()
		else:
			board_array[i] = tetromino_type
	for i in range(40):
		if board_array[i]:
			gameOver.emit()
	updateBoard()

#Displays un-displayed squares, clears empty spaces
func updateBoard():
	for square in get_children():
		var square_index = int(square.name.get_slice('Square',1))
		if !board_array[square_index]:
			square.free()
		elif board_array[square_index] != Globals.Tetromino.find_key(square_index):
			square.set_frame(Globals.Tetromino[board_array[int(square.name.get_slice('Square',1))]])
	for i in board_array.size():
		if board_array[i] and !has_node("Square" + str(i)):
			var x = i % 10
			var y = i / 10
			var new_square = load("res://Tetromino/tetromino_square.tscn").instantiate()
			add_child(new_square)
			new_square.position = Vector2(x + .5,y - 3.5) * 32
			new_square.name = "Square" + str(i)
			new_square.set_frame(Globals.Tetromino[board_array[i]])
	checkForFullRow()

#Provided and array of array location, checks for overlap between the array and the board array
func checkForOverlap(tetromino_array):
	for i in tetromino_array:
		if i > 239:
			return false #There is overflow through bottom of board
		elif board_array[i]:
			return false #There is overlap
	return true #There is no overlap

func checkForFullRow():
	var rows_to_clear = 0
	for row in range(24):
		var row_is_full = true
		for i in range(10):
			if !board_array[row*10 + i]:
				row_is_full = false
		if row_is_full:
			rows_to_clear += 1
			clearRow(row)
	if rows_to_clear >= 4:
		increaseScore.emit(400 * Globals.level)
	elif rows_to_clear >= 3:
		increaseScore.emit(300 * Globals.level)
	elif rows_to_clear >= 2:
		increaseScore.emit(200 * Globals.level)
	elif rows_to_clear >= 1:
		increaseScore.emit(100 * Globals.level)

func clearRow(row):
	rowCleared.emit()
	while row > 0:
		for i in range(10):
			board_array[row*10 + i] = board_array[row*10 + i - 10]
		row -= 1
	updateBoard()

func clearBoard():
	board_array.fill('')
	updateBoard()
