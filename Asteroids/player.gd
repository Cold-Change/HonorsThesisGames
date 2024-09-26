extends CharacterBody2D

@export var speed = 1000
@export var acceleration = 200

func _physics_process(delta):
	handleMovement(delta)
	move_and_slide()

func handleMovement(delta):
	var turn = Input.get_axis("left","right")
	if Input.is_action_pressed("propulsion"):
		velocity.x = move_toward(velocity.x,speed,sin(rotation)*acceleration*delta)
		velocity.y = move_toward(velocity.y,speed,-cos(rotation)*acceleration*delta)
	if turn:
		rotate(PI*turn*delta)
