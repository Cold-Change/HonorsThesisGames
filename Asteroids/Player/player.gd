extends CharacterBody2D

@export var speed = 250
@export var acceleration = 600
@onready var init_acceleration = acceleration

@onready var area_2d = $Area2D
@onready var invulnerability_timer = $Timers/Invulnerability

signal receiveDamage

func _physics_process(delta):
	handleMovement(delta)
	handleInvulnerability()
	move_and_slide()

func handleMovement(delta):
	var turn = Input.get_axis("left","right")
	if Input.is_action_pressed("propulsion"):
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
	if turn:
		rotate(PI*turn*delta)

func handleInvulnerability():
	if invulnerability_timer.is_stopped():
		visible = true
	else:
		if int(floor(invulnerability_timer.time_left*2)) % 2 == 0:
			visible = false
		else:
			visible = true
	

func _on_area_2d_body_entered(body):
	if body.has_method("break"):
		body.break()
	receiveDamage.emit()
	area_2d.set_deferred("monitoring",false)
	acceleration = 100
	invulnerability_timer.start()

func _on_invulnerability_timeout():
	area_2d.set_deferred("monitoring",true)
	acceleration = init_acceleration
