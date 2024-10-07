extends Node2D

@onready var movement_timer = $MovementTimer

var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")

var tetromino = preload("res://Tetromino/tetromino.tscn")

func _ready():
	movement_timer.start()

func _physics_process(delta):
	if Input.is_action_just_pressed("accept"):
		var new_tetromino = tetromino.instantiate()
		add_child(new_tetromino)
		new_tetromino.position = Vector2(window_width/2,32)
		new_tetromino.initTetromino(Globals.Tetromino.keys()[randi() % Globals.Tetromino.size()])
		movement_timer.start()
	if has_node("Tetromino"):
		if Input.is_action_just_pressed("up"):
			get_node("Tetromino").rotation += PI/2
			for square in get_node("Tetromino").get_children():
				square.rotation -= PI/2
		if Input.is_action_just_pressed("right"):
			get_node("Tetromino").position.x += 32
		if Input.is_action_just_pressed("left"):
			get_node("Tetromino").position.x -= 32
func _on_movement_timer_timeout():
	if has_node("Tetromino"):
		get_node("Tetromino").position.y += 32
