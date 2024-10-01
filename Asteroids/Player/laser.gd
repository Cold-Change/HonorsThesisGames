extends RigidBody2D

var angle : float
var speed : Vector2
var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _physics_process(delta):
	if position.x < 0:
		queue_free()
	elif position.x > window_width:
		queue_free()
	elif position.y < 0:
		queue_free()
	elif position.y > window_height:
		queue_free()
	move_and_collide(speed*delta)

func _on_area_2d_body_entered(body):
	if body.has_method("breakAsteroid"):
		body.call_deferred("breakAsteroid")
	queue_free()

func set_speed():
	speed.x += sin(angle) * 300
	speed.y += -cos(angle) * 300
	print(angle)
