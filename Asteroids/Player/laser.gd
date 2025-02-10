extends RigidBody2D

var angle : float
var speed : Vector2

func _physics_process(delta):
	move_and_collide(speed*delta)

func set_speed():
	speed.x += sin(angle) * 400
	speed.y += -cos(angle) * 400

func _on_area_2d_body_entered(body):
	if body.has_method("breakAsteroid") and body.size <= 0:
		Globals.score += 1000 / (5)
		Globals.life_talley += 0.2
		body.call_deferred("breakAsteroid")
	elif body.has_method("breakAsteroid"):
		Globals.score += 1000 / (body.size * 5)
		Globals.life_talley += 1.0 / (body.size * 5)
		body.call_deferred("breakAsteroid")
	queue_free()

func _on_clear_timer_timeout():
	queue_free()
