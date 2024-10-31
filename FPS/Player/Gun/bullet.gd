extends Node3D

var player = 1
var speed = 40
var damage = 20
var collisionMade = false

@onready var clear_timer = $ClearTimer

signal playerTakeDamage(player,damage)

func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta

func destroyBullet():
	queue_free()

func _on_clear_timer_timeout():
	destroyBullet()

func _on_hit_box_body_entered(body):
	if !collisionMade:
		if body.get_collision_layer() == 4:
			playerTakeDamage.emit(player,damage*.5)
			print(body.get_collision_layer())
		elif body.get_collision_layer() == 8:
			playerTakeDamage.emit(player,damage*.75)
			print(body.get_collision_layer())
		elif body.get_collision_layer() == 16:
			playerTakeDamage.emit(player,damage)
			print(body.get_collision_layer())
		elif body.has_method("takeDamage"):
			body.takeDamage(damage)
			print(body.get_collision_layer())
	collisionMade = true
	destroyBullet()
