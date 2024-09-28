extends RigidBody2D

#func _ready():
	#linear_velocity = Vector2(200,100)

func _physics_process(delta):
	move_and_collide(Vector2(2,1))
