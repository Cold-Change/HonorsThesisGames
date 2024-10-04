extends Node2D

@onready var player = $Player
@onready var ui = $UI
@onready var ui_lives = $UI/Lives
@onready var asteroids = $Asteroids
@onready var score_labels = $UI/Scores
@onready var high_score_label = $UI/Scores/HighScore
@onready var score_label = $UI/Scores/Score
@onready var game_over_labels = $UI/GameOver
@onready var game_over_text = $UI/GameOver/VBoxContainer/GameOverText
@onready var score_text = $UI/GameOver/VBoxContainer/HBoxContainer/ScoreText
@onready var high_score_text = $UI/GameOver/VBoxContainer/HBoxContainer/HighScoreText

var lives : int
var state = "start"

var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.receiveDamage.connect(playerIsDamaged)
	high_score_label.text = "High Score: " + str(Globals.high_score)
	game_over_labels.visible = true
	score_labels.visible = false
	#clearAsteroids()
	updateLives()
	resetPlayerPosition()

func _process(delta):
	runStateMachine()
	updateScoreLabel()
	for asteroid in asteroids.get_children():
		checkPosition(asteroid)

func checkPosition(obj):
	if obj.position.x < 0:
		obj.position.x = window_width
	elif obj.position.x > window_width:
		obj.position.x = 0
	if obj.position.y < 0:
		obj.position.y = window_height
	elif obj.position.y > window_height:
		obj.position.y = 0

func updateScoreLabel():
	score_label.text = "Score: " + str(Globals.score)
	if Globals.score > Globals.high_score:
		Globals.high_score = Globals.score
		high_score_label.text = "High Score: " + str(Globals.high_score)

func updateLives():
	for i in ui_lives.get_children():
		i.queue_free()
	for i in range(lives):
		var poly = Polygon2D.new()
		poly.set_polygon(player.get_node("Polygon2D").get_polygon())
		poly.position = Vector2(30 + 30 * i,window_height - 30)
		poly.name = "Life" + str(i+1)
		ui_lives.add_child(poly)

func playerIsDamaged():
	lives -= 1
	if lives < 0:
		gameOver()
		state = "game_over"
	else:
		updateLives()
		player.velocity *= -.05

func gameOver():
	game_over_text.text = "GAME OVER"
	score_text.text = "Score: " + str(Globals.score)
	high_score_text.text = "High Score: " + str(Globals.high_score)
	toggleUIVisibility()
	resetPlayerPosition()

func toggleUIVisibility():
	game_over_labels.visible = !game_over_labels.visible
	score_labels.visible = !score_labels.visible

func runStateMachine():
	if Input.is_action_just_pressed("accept"):
		if state == "start":
			state = "running"
			Globals.score = 0
			initPlayer()
			toggleUIVisibility()
		elif state == "game_over":
			state = "start"
			game_over_text.text = "PLAY AGAIN?"
	if state == "running":
		checkPosition(player)
	if state == "start" and game_over_labels.visible == true:
		game_over_text.text = "PLAY AGAIN?"

func resetPlayerPosition():
	player.visible = false
	player.position = Vector2(window_width,window_height)/2
	player.rotation = 0
	get_tree().paused = true

func initPlayer():
	get_tree().paused = false
	player.visible = true
	player.position = Vector2(window_width,window_height)/2
	player.rotation = 0
	player.velocity = Vector2.ZERO
	player.initInvulnerability()
	lives = 3
	updateLives()

func clearAsteroids():
	for asteroid in asteroids.get_children():
		asteroid.queue_free()
