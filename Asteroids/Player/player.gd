extends CharacterBody2D

@export var speed = 250
@export var acceleration = 400
@onready var init_acceleration = acceleration
@onready var friction = 100
@onready var init_friction = friction

@onready var area_2d = $Area2D
@onready var invulnerability_timer = $Timers/Invulnerability

signal receiveDamage

func _physics_process(delta):
	handleMovement(delta)
	if Input.is_action_just_pressed("fire"):
		fireLaser()
	handleInvulnerability()
	move_and_slide()

func handleMovement(delta):
	var turn = Input.get_axis("left","right")
	if Input.is_action_pressed("propulsion"):
		applyAcceleration(delta)
	applyFriction(delta)
	if turn:
		rotate(PI*turn*delta)

func applyAcceleration(delta):
	if velocity.x + sin(rotation)*acceleration*delta > speed:
		velocity.x = speed
	elif velocity.x + sin(rotation)*acceleration*delta < -speed:
		velocity.x = -speed
	else:
		velocity.x += sin(rotation)*acceleration*delta
	if velocity.y + -cos(rotation)*acceleration*delta > speed:
		velocity.y = speed
	elif velocity.y + -cos(rotation)*acceleration*delta < -speed:
		velocity.y = -speed
	else:
		velocity.y += -cos(rotation)*acceleration*delta

func applyFriction(delta):
	velocity.x = move_toward(velocity.x,0,friction*delta)
	velocity.y = move_toward(velocity.y,0,friction*delta)

func fireLaser():
	var new_laser = load("res://Player/laser.tscn").instantiate()
	var lasers = get_parent().get_node("Lasers")
	lasers.add_child(new_laser)
	new_laser.angle = rotation
	new_laser.rotation = rotation
	new_laser.position.x = position.x + sin(rotation) * 30
	new_laser.position.y = position.y + -cos(rotation) * 30
	new_laser.set_speed()

func handleInvulnerability():
	if invulnerability_timer.is_stopped():
		visible = true
	else:
		if int(floor(invulnerability_timer.time_left*2.5)) % 2 == 0:
			visible = false
		else:
			visible = true

func initInvulnerability():
	area_2d.set_deferred("monitoring",false)
	acceleration = 200
	friction = 50
	invulnerability_timer.start()

func _on_area_2d_body_entered(body):
	if body.has_method("breakAsteroid"):
		body.call_deferred("breakAsteroid")
	receiveDamage.emit()
	initInvulnerability()

func _on_invulnerability_timeout():
	area_2d.set_deferred("monitoring",true)
	acceleration = init_acceleration
	friction = init_friction
