extends CharacterBody2D

@export var speed = 200
@export var jump_velocity = -250
@onready var can_jump = true
@onready var can_double_jump = true
@export var double_jump_unlocked = true
@export var wall_jump_unlocked = true

@onready var gravity_scale = 1
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var friction = 1000
@onready var air_resistance = 250

@onready var last_wall_normal = Vector2.ZERO

@onready var coyote_time = $Timers/CoyoteTime
@onready var wall_jump_time = $Timers/WallJumpTime

func _physics_process(delta):
	var was_on_wall_only = is_on_wall_only()
	var was_on_floor = is_on_floor()
	if is_on_wall():
		last_wall_normal = get_wall_normal()
	if not is_on_floor():
		apply_gravity(delta)
	handle_movement(delta)
	handle_friction(delta)
	handle_jump()
	manage_timers(was_on_wall_only, was_on_floor)
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * gravity_scale * delta
	
func handle_movement(delta):
	var direction = Input.get_axis("left", "right")
	var acceleration = speed * 10
	var air_acceleration = speed * 5
	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * speed, air_acceleration * delta)

func handle_friction(delta):
	if is_on_wall_only() and (velocity.y + gravity * delta) >= 100:
		velocity.y = 100
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_resistance * delta)

func handle_jump():
	if is_on_floor():
		can_jump = true
		can_double_jump = true
	if Input.is_action_just_pressed("jump") and coyote_time.time_left > 0 and can_jump:
		velocity.y = jump_velocity
		can_jump = false
	elif Input.is_action_pressed("jump") and is_on_floor() and can_jump:
		velocity.y = jump_velocity
		can_jump = false
	elif double_jump_unlocked:
		handle_double_jump()
	if wall_jump_unlocked:
		handle_wall_jump()

func handle_wall_jump():
	if Input.is_action_just_pressed("jump") and wall_jump_time.time_left > 0:
		velocity.y = jump_velocity
		velocity.x = last_wall_normal.x * speed
		can_double_jump = true
	elif Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = jump_velocity
		velocity.x = last_wall_normal.x * speed
		can_double_jump = true

func handle_double_jump():
	if wall_jump_unlocked:
		if Input.is_action_just_pressed("jump") and not is_on_floor() and not is_on_wall() and can_double_jump:
			velocity.y = jump_velocity
			can_double_jump = false
	else:
		if Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump:
			velocity.y = jump_velocity
			can_double_jump = false

func manage_timers(was_on_wall, was_on_floor):
	if (was_on_wall and not is_on_wall()) or is_on_wall_only():
		wall_jump_time.start()
	if (was_on_floor and not is_on_floor() and velocity.y >= 0) or is_on_floor():
		coyote_time.start()
