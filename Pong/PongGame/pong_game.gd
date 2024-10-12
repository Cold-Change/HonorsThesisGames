extends Node2D

@onready var p1_score_label = $ColorRect/CenterContainer/P1Score
@onready var p2_score_label = $ColorRect/CenterContainer/P2Score
@onready var game_over_message = $ColorRect/GameOverMessage
@onready var game_over_message_2 = $ColorRect/GameOverMessage2


@onready var ball = $Ball
@onready var state = "start"
@onready var paddle_zone = "Up2"
var p1_score = 0
var p2_score = 0
var turn = 0

func _physics_process(_delta):
	#Simple state machine
	#If in play, run checkPosition
	#If in start and player starts the game, initialize play
	#If in game over and player resets the game, restart the game
	if state == "play":
		checkPosition()
	elif state == "start" and Input.is_action_just_pressed("accept"):
		state = "play"
		initBallMovement()
	elif state == "game_over" and Input.is_action_just_pressed("accept"):
		restartGame()

#Checks the position of the ball
func checkPosition():
	#When the ball crosses the boarder of the screen, add a point to the opposite side
	if ball.position.x < 0:
		p2_score += 1
	elif ball.position.x > 1280:
		p1_score += 1
	#When the ball gets past either boarder, update score labels, 
	#check for a winner, and reset the play area
	if ball.position.x < 0 or ball.position.x > 1280:
		p1_score_label.text = str(p1_score)
		p2_score_label.text = str(p2_score)
		checkWinner()
		resetPlayArea()

#Resets ball position and speed as well as game state
func resetPlayArea():
	ball.position = Vector2(640,360)
	ball.velocity = Vector2.ZERO
	ball.speed = Vector2.ZERO
	if state != "game_over":
		state = "start"

#Initializes ball movement
func initBallMovement():
	if turn % 2 == 0:
		ball.speed = Vector2(ball.initSpeed,randi_range(-ball.initSpeed,ball.initSpeed))
	else:
		ball.speed = Vector2(-ball.initSpeed,randi_range(-ball.initSpeed,ball.initSpeed))
	turn += 1

#Checks for winner and ends game if a winner is found
func checkWinner():
	if p1_score >= 11 or p2_score >= 11:
		game_over_message_2.visible = true
		if p1_score >= 11:
			game_over_message.text = "PLAYER 1 WINS!"
		else:
			game_over_message.text = "PLAYER 2 WINS!"
		game_over_message.visible = true
		state = "game_over"

#Full reset of the game
#Scores are cleared, labels are reset, state is changed
func restartGame():
	p1_score = 0
	p2_score = 0
	turn = 0
	game_over_message.visible = false
	game_over_message_2.visible = false
	p1_score_label.text = str(p1_score)
	p2_score_label.text = str(p2_score)
	state = "start"
	resetPlayArea()
	
