extends Node

enum Tetromino {
	I,J,L,O,S,T,Z
}

var cells = {
	Tetromino.I: [Vector2(-2, 0), Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0)],
	Tetromino.J: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	Tetromino.L: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0 )],
	Tetromino.O: [Vector2(-1,0), Vector2(-1,1), Vector2(0,0), Vector2(0,1)],
	Tetromino.S: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)],
	Tetromino.T: [Vector2(0,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	Tetromino.Z: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)]
}

var high_score = 0
