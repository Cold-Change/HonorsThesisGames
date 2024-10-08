extends Node

var board_array : Array[String] = []

func _ready():
	board_array.resize(240)
	board_array.fill('')

#func checkForTetrominoToBoard():
	#for square in get_node("Tetromino").get_children():
		##if floor(get_node("Tetromino").rotation) == 1:
			##
		##elif floor(get_node("Tetromino").rotation) == 3:
			##
		##elif floor(get_node("Tetromino").rotation) == 4:
			##
		##else:
		#if ceil((get_node("Tetromino").position.y + square.position.y) / 32) == 20:
			#tetrominoToBoard()
			#break
#
#func tetrominoToBoard():
	#var termino_position = get_node("Tetromino").position / 32
	#for i in Globals.cells[Globals.Tetromino[get_node("Tetromino").shape]]:
		#i += termino_position
		#board_array[i.x + i.y*10 + 30] = get_node("Tetromino").shape
	#print(board_array)
	#get_node("Tetromino").free()
	#updateBoard()
	#createNewTetromino()
#
#func updateBoard():
	#for i in board_array:
		#if i:
			#var new_square = load("res://Tetromino/tetromino_square.tscn").instantiate()
			#board.add_child(new_square)
			#new_square.get_node("TetrominoSquares-sheet").set_frame(Globals.Tetromino[i])
