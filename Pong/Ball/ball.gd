extends CharacterBody2D

@export var initSpeed = 300
@onready var speed = Vector2.ZERO

func _physics_process(_delta):
	runMovementBehavior()
	move_and_slide()

#Regulates the movement of the ball scene
func runMovementBehavior():
	velocity = speed
	
	#Upon collision with a surface, run this behavior
	if is_on_wall():
		var normal = get_wall_normal()
		
		#If ball collides with paddle, run this behavior
		if normal.x and $RefX.is_stopped():
			speed.x = -speed.x
			speed.x *= 1.05
			
			#Based on distance from paddle center, increase or decrease vertical speed
			if position.x > 640:
				speed.y = (position.y - Globals.paddle2_position.y)/50 * abs(speed.x)
			else:
				speed.y = (position.y - Globals.paddle1_position.y)/50 * abs(speed.x)
			$RefX.start()
		
		#If ball collided with wall, run this behavior
		if normal.y and $RefY.is_stopped():
			speed.y = -speed.y
			$RefY.start()
