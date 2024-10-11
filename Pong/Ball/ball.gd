extends CharacterBody2D

@export var initSpeed = 300
@onready var speed = Vector2.ZERO
@onready var paddle_zone = "Up2"

func _physics_process(_delta):
	runMovementBehavior()
	move_and_slide()

#Regulates the movement of the ball scene
func runMovementBehavior():
	velocity = Vector2(speed[0],speed[1])
	
	#Upon collision with a surface, run this behavior
	if is_on_wall():
		var normal = get_wall_normal()
		
		#If ball collides with paddle, run this behavior
		if normal.x and $RefX.is_stopped():
			speed[0] = -speed[0]
			speed[0] *= 1.05
			
			#Based on paddle zone, increase or decrease vertical speed
			if paddle_zone == "Up2":
				speed[1] -= abs(speed[0]*0.5)
			elif paddle_zone == "Up1":
				speed[1] -= abs(speed[0]*0.25)
			elif paddle_zone == "Down1":
				speed[1] += abs(speed[0]*0.25)
			elif paddle_zone == "Down2":
				speed[1] += abs(speed[0]*0.5)
			$RefX.start()
		
		#If ball collided with wall, run this behavior
		if normal.y and $RefY.is_stopped():
			speed[1] = -speed[1]
			$RefY.start()
