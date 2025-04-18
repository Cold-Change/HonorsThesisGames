extends Node2D

var cells = Globals.cells
var tetromino = Globals.Tetromino
var shape : String

func initTetromino(tetromino_type):
	shape = tetromino_type
	for i in cells[tetromino[tetromino_type]]:
		var new_square = load("res://Tetromino/tetromino_square.tscn").instantiate()
		if i != Vector2.ZERO:
			add_child(new_square)
			new_square.position.x += i.x * 32
			new_square.position.y += i.y * 32
			new_square.name = "TetrominoSquare"
	for child in get_children():
		child.set_frame(tetromino[tetromino_type])
