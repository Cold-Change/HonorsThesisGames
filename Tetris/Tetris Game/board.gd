extends Node

var board_array : Array[String] = []

func _ready():
	board_array.resize(240)
	board_array.fill('')

func lockTetrominoToBoard(tetromino_array,tetromino_type):
	for i in tetromino_array:
		board_array[i] = tetromino_type
	updateBoard()

func updateBoard():
	for square in get_children():
		if !board_array[int(square.name.get_slice('Square',1))]:
			square.free()
	for i in board_array.size():
		if board_array[i] and !has_node("Square" + str(i)):
			var x = i % 10
			var y = i / 10
			var new_square = load("res://Tetromino/tetromino_square.tscn").instantiate()
			add_child(new_square)
			new_square.position = Vector2(x + .5,y - 3.5) * 32
			new_square.name = "Square" + str(i)
			new_square.get_node("TetrominoSquares-sheet").set_frame(Globals.Tetromino[board_array[i]])

func checkForOverlap(tetromino_array):
	for i in tetromino_array:
		if board_array[i]:
			return false #There is overlap
	return true #There is no overlap
