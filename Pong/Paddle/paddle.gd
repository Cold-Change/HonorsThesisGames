extends CharacterBody2D

@export var player_num : int
@export var speed = 300

func _physics_process(delta):
	var direction : float
	var up_is_pressed : bool
	var down_is_pressed : bool
	if player_num == 1:
		direction = Input.get_axis("up1","down1")
		up_is_pressed = Input.is_action_pressed("up1")
		down_is_pressed = Input.is_action_pressed("down1")
	elif player_num == 2:
		direction = Input.get_axis("up2","down2")
		up_is_pressed = Input.is_action_pressed("up2")
		down_is_pressed = Input.is_action_pressed("down2")
	if up_is_pressed and down_is_pressed:
		velocity.y = 0
	elif direction:
		velocity.y = speed * direction
	else:
		velocity.y = 0
	move_and_slide()
