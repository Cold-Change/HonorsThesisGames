extends Node2D

@onready var ball = $Ball
var p1_score = 0
var p2_score = 0
var turn = 0

func _physics_process(delta):
	checkPosition()
	if ball.velocity == Vector2.ZERO and Input.is_action_just_pressed("accept"):
		initBallMovement()
	
func checkPosition():
	if ball.position.x < 0:
		p2_score += 1
	elif ball.position.x > 1280:
		p1_score += 1
	if ball.position.x < 0 or ball.position.x > 1280:
		resetPlayArea()

func resetPlayArea():
	ball.position = Vector2(640,360)
	ball.velocity = Vector2.ZERO
	ball.speed = Vector2.ZERO

func initBallMovement():
	if turn % 2 == 0:
		ball.speed = [ball.initSpeed,randi_range(-ball.initSpeed*1.5,ball.initSpeed*1.5)]
	else:
		ball.speed = [-ball.initSpeed,randi_range(-ball.initSpeed*1.5,ball.initSpeed*1.5)]
	turn += 1
