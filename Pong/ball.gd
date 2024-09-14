extends CharacterBody2D

var speed = [200,200]

func _physics_process(delta):
	velocity = Vector2(speed[0],speed[1])
	if is_on_wall():
		var normal = get_wall_normal()
		if normal.x and $RefX.is_stopped():
			speed[0] = -speed[0]
			$RefX.start()
		if normal.y and $RefY.is_stopped():
			speed[1] = -speed[1]
			$RefY.start()
	move_and_slide()

