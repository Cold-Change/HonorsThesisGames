extends CharacterBody2D

@export var player_num : int
@export var speed = 300
signal paddleZone

func _physics_process(_delta):
	var direction : float
	var up_is_pressed : bool
	var down_is_pressed : bool
	
	#Paddle movement is dictated by player 1 OR player 2
	#Player 1 uses "WASD"
	#Player 2 uses arrow keys
	if player_num == 1:
		direction = Input.get_axis("up1","down1")
		up_is_pressed = Input.is_action_pressed("up1")
		down_is_pressed = Input.is_action_pressed("down1")
	elif player_num == 2:
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

#Signal emitting functions
#Used to affect angle of reflection of ball with paddle
#Signal is used by the pong game scene which passes the call to 
#a child ball scene
func _on_down_2_body_entered(_body):
	paddleZone.emit("Down2")

func _on_down_1_body_entered(_body):
	paddleZone.emit("Down1")

func _on_up_1_body_entered(_body):
	paddleZone.emit("Up1")

func _on_up_2_body_entered(_body):
	paddleZone.emit("Up2")
