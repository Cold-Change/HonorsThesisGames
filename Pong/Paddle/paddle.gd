extends CharacterBody2D

@export var player_num : int
@export var speed = 300

func _physics_process(_delta):
	var direction : float
	var up_is_pressed : bool
	var down_is_pressed : bool
	
	#Paddle movement is dictated by player 1 OR player 2
	#Player 1 uses "WASD"
	#Player 2 uses arrow keys
	if player_num == 1:
		Globals.paddle1_position = position
		direction = Input.get_axis("up1","down1")
		up_is_pressed = Input.is_action_pressed("up1")
		down_is_pressed = Input.is_action_pressed("down1")
	elif player_num == 2:
		Globals.paddle2_position = position
		direction = Input.get_axis("up2","down2")
		up_is_pressed = Input.is_action_pressed("up2")
		down_is_pressed = Input.is_action_pressed("down2")
	
	#Move if one direction is pressed
	#Don't move if no direction is pressed or both directions are pressed
	if up_is_pressed and down_is_pressed:
		velocity.y = 0
	elif direction:
		velocity.y = speed * direction
	else:
		velocity.y = 0
	move_and_slide()
