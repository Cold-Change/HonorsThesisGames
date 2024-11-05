extends CharacterBody3D

@export var entity_num = -1
@onready var player_model = $PlayerModel
@onready var player_ui = $PlayerUI

var base_speed = 6.0
var crouch_speed = 3.0
var sprint_speed = 9.0
var speed = 0

var jump = 4.5
var health = 100.0
@onready var init_position = position
@onready var init_basis = transform.basis

@onready var animation_refractory_timer = $AnimationRefractoryTimer
var animation_refractory = false

var walking = false
var crouched = false
var just_crouched = false
var just_stood = false
var just_jumped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sens = 0.15
var camera_mode = "first"

const COLORS = {"Red": Color("e74f56"),"Yellow": Color("e7e219"),"Blue": Color("6572e7"),"Green": Color("49e76b"),"Orange": Color("e78c25"),"Cyan": Color("49e2e7")}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_ui.updateHealthBar(health)
	#changeColor("Blue")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	handleCrouch()
	
	handleSprint()
	
	handleJump()
	
	handleMovement()
	
	handleAnimations()
	
	handleCamera()
	
	move_and_slide()

func _unhandled_input(event):
	#Handle camera and character rotation
	if event is InputEventMouseMotion:
		var change_v = -event.relative.y*mouse_sens
		var change_h = -event.relative.x*mouse_sens
		rotation.y += deg_to_rad(change_h)
		player_model.updateChestRot(deg_to_rad(-change_v)*1/2)
		player_model.updateSpineRot(deg_to_rad(-change_v)*1/2)

func takeDamage(damage):
	health -= damage
	player_ui.updateHealthBar(health)
	if health <= 0:
		die()

func handleCrouch():
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		if !crouched:
			just_crouched = true
		else:
			just_stood = true
		crouched = !crouched

func handleSprint():
	if crouched:
		speed = crouch_speed
	else:
		if Input.is_action_pressed("sprint"):
			speed = sprint_speed
		else:
			speed = base_speed

func handleJump():
	if Input.is_action_pressed("jump") and is_on_floor() and !crouched:
		velocity.y = jump
		just_jumped = true

func handleMovement():
	var input_direction = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if direction:
		velocity.x = -direction.x * speed
		velocity.z = -direction.z * speed
		walking = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		walking = false

func handleAnimations():
	if just_jumped:
		player_model.state_machine.travel("JumpGun")
		just_jumped = false
		animation_refractory_timer.start()
	if just_crouched:
		player_model.travelToCrouchedState()
		just_crouched = false
		animation_refractory_timer.start()
	if just_stood:
		player_model.travelToStandingState()
		just_stood = false
		animation_refractory_timer.start()
	
	if !animation_refractory_timer.is_stopped():
		animation_refractory = true
	else:
		animation_refractory = false
	
	if !(player_model.state_machine.get_current_node() in ["StandGun","CrouchGun","JumpGun","JumpGun 2"]) and !animation_refractory:
		if crouched:
			player_model.travelInCrouchedState(walking)
		else:
			player_model.travelInStandingState(walking)

func handleCamera():
	if Input.is_action_just_pressed("toggle_camera"):
		if camera_mode == "third":
			player_model.first_person_camera.current = true
			camera_mode = "first"
		elif camera_mode == "first":
			player_model.third_person_camera.camera.current = true
			camera_mode = "third"

func getEntity():
	return entity_num

func reset():
	transform.basis = init_basis
	position = init_position
	health = 100.0
	player_ui.updateHealthBar(health)

func die():
	reset()

func changeColor(color):
	for mesh in player_model.skeleton_3d.get_children():
		if mesh is MeshInstance3D:
			mesh.mesh.surface_get_material(0).albedo_color = COLORS[color]
