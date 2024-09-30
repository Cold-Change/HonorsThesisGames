extends RigidBody2D
class_name Asteroid

@onready var size = 5
@onready var splits = 4
@onready var speed : Vector2

func _ready():
	initMovement()

func _physics_process(delta):
	move_and_collide(speed*delta)

func breakAsteroid():
	if splits:
		var new_asteroid_1 = load("res://Asteroid/asteroid.tscn").instantiate()
		get_parent().add_child(new_asteroid_1)
		new_asteroid_1.size = size - 1
		new_asteroid_1.splits = splits - 1
		new_asteroid_1.position = position
		new_asteroid_1.initMovement()
		var new_asteroid_2 = load("res://Asteroid/asteroid.tscn").instantiate()
		get_parent().add_child(new_asteroid_2)
		new_asteroid_2.size = size - 1
		new_asteroid_2.splits = splits - 1
		new_asteroid_2.position = position
		new_asteroid_2.initMovement()
	queue_free()

func initMovement():
	var angle = randf_range(-PI,PI)
	if size == 5:
		speed = Vector2(randi_range(200,250)*sin(angle),randi_range(200,250)*-cos(angle))
	elif size == 4:
		speed = Vector2(randi_range(200,250)*sin(angle),randi_range(200,250)*-cos(angle))
		scale *= .75
	elif size == 3:
		speed = Vector2(randi_range(300,350)*sin(angle),randi_range(300,350)*-cos(angle))
		scale *= .5
	elif size == 2:
		speed = Vector2(randi_range(400,450)*sin(angle),randi_range(400,450)*-cos(angle))
		scale *= .25
	elif size == 1:
		speed = Vector2(randi_range(500,550)*sin(angle),randi_range(500,550)*-cos(angle))
		scale *= .15
