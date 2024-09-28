extends CharacterBody2D

@export var speed = 750
@export var acceleration = 250

@onready var area_2d = $Area2D
@onready var invulnerability_timer = $Timers/Invulnerability

signal receiveDamage

func _physics_process(delta):
	handleMovement(delta)
	
	move_and_slide()

func handleMovement(delta):
	var turn = Input.get_axis("left","right")
	if Input.is_action_pressed("propulsion"):
		velocity.x = move_toward(velocity.x,speed,sin(rotation)*acceleration*delta)
		velocity.y = move_toward(velocity.y,speed,-cos(rotation)*acceleration*delta)
	if turn:
		rotate(PI*turn*delta)

func _on_area_2d_body_entered(body):
	if body.has_method("break"):
		body.break()
	receiveDamage.emit()
	area_2d.set_deferred("monitoring",false)
	invulnerability_timer.start()

func _on_invulnerability_timeout():
	area_2d.set_deferred("monitoring",true)
