extends CharacterBody3D

@onready var camera_origin = $CameraOrigin
@onready var camera = $CameraOrigin/PlayerCamera

const SPEED = 6.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sens = 0.3
var camera_angle_v=0
var camera_mode = "third"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("toggle_camera"):
		if camera_mode == "third":
			camera_origin.rotation.y += PI
			camera_mode = "front"
		elif camera_mode == "front":
			camera_origin.rotation.y -= PI
			camera.position.z -= 2.1
			camera_origin.position.y += 0.8
			camera_mode = "first"
		elif camera_mode == "first":
			camera.position.z += 2.1
			camera_origin.position.y -= 0.8
			camera_mode = "third"
	
	move_and_slide()


func _unhandled_input(event):
	#Handle camera and character rotation
	if event is InputEventMouseMotion:
		var change_v = -event.relative.y*mouse_sens
		var change_h = -event.relative.x*mouse_sens
		rotation.y += deg_to_rad(change_h)
		#if camera_mode == "third":
		if !(camera_origin.rotation.x + deg_to_rad(change_v) > PI/8 or camera_origin.rotation.x + deg_to_rad(change_v) < -2*PI/5):
			camera_origin.rotation.x += deg_to_rad(change_v)
		#elif camera_mode == "front":
			#if !(camera_origin.rotation.x + deg_to_rad(change_v) > PI/8 or camera_origin.rotation.x + deg_to_rad(change_v) < -2*PI/5):
				#camera_origin.rotation.x += deg_to_rad(change_v)

