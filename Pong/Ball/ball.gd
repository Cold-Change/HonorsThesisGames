extends CharacterBody2D

@export var initSpeed = 200
@onready var speed = Vector2.ZERO

func _physics_process(_delta):
	runMovementBehavior()
	move_and_slide()

func runMovementBehavior():
	velocity = Vector2(speed[0],speed[1])
	if is_on_wall():
		var normal = get_wall_normal()
		if normal.x and $RefX.is_stopped():
			speed[0] = -speed[0]
			$RefX.start()
			speed[0] *= 1.05
			speed[1] *= 1.05
		if normal.y and $RefY.is_stopped():
			speed[1] = -speed[1]
			$RefY.start()
