extends RigidBody2D
class_name Asteroid

var size = 5
var splits = 1
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
		speed = Vector2(randi_range(50,100)*sin(angle),randi_range(50,100)*-cos(angle))
	elif size == 4:
		speed = Vector2(randi_range(125,175)*sin(angle),randi_range(125,175)*-cos(angle))
		scale *= .8
	elif size == 3:
		speed = Vector2(randi_range(225,275)*sin(angle),randi_range(225,275)*-cos(angle))
		scale *= .6
	elif size == 2:
		speed = Vector2(randi_range(350,400)*sin(angle),randi_range(350,400)*-cos(angle))
		scale *= .4
	else:
		speed = Vector2(randi_range(450,500)*sin(angle),randi_range(450,500)*-cos(angle))
		scale *= .2
