extends CharacterBody3D

@onready var player_model = $PlayerModel
@onready var player_ui = $PlayerUI
var player_num = 1

var speed = 6.0
var jump = 4.5
var health = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sens = 0.3
var camera_angle_v=0
var camera_mode = "first"


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_ui.updateHealthBar(health)
	if has_node("PlayerModel/Armature/Skeleton3D/HandRAttatchment/Gun"):
		get_node("PlayerModel/Armature/Skeleton3D/HandRAttatchment/Gun").emitPlayerDamage.connect(takeDamage)
	#takeDamage.connect(preload("res://Player/Gun/bullet.gd").playerTakeDamage)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = -direction.x * speed
		velocity.z = -direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.is_action_just_pressed("toggle_camera"):
		if camera_mode == "third":
			player_model.first_person_camera.current = true
			camera_mode = "first"
		elif camera_mode == "first":
			player_model.third_person_camera.current = true
			camera_mode = "third"
	move_and_slide()

func _unhandled_input(event):
	#Handle camera and character rotation
	if event is InputEventMouseMotion:
		var change_v = -event.relative.y*mouse_sens
		var change_h = -event.relative.x*mouse_sens
		rotation.y += deg_to_rad(change_h)
		player_model.updateChestRot(deg_to_rad(-change_v)*1/2)
		player_model.updateSpineRot(deg_to_rad(-change_v)*1/2)

func takeDamage(player,damage):
	if player_num == player:
		health -= damage
		player_ui.updateHealthBar(health)
