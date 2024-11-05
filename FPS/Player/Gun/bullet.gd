extends Node3D

var speed = 80
var damage = 20
var collisionMade = false

@onready var clear_timer = $ClearTimer

signal entityTakeDamage(entity,damage)

func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta

func destroyBullet():
	queue_free()

func _on_clear_timer_timeout():
	destroyBullet()

func _on_hit_box_body_entered(body):
	if !collisionMade:
		var entity = body.get_parent().get_parent().get_parent().get_parent().get_parent()
		if body.get_collision_layer() == 4:
			entityTakeDamage.emit(entity.entity_num,damage*.5)
		elif body.get_collision_layer() == 8:
			entityTakeDamage.emit(entity.entity_num,damage*.75)
		elif body.get_collision_layer() == 16:
			entityTakeDamage.emit(entity.entity_num,damage)
		elif body.has_method("takeDamage"):
			body.takeDamage(damage)
	collisionMade = true
	destroyBullet()
