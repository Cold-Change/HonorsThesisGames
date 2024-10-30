extends Node3D

@onready var bullet_path = $BulletPath
@onready var bullets = $Bullets
var mouse_sens = 0.3

var bullet = load("res://Player/Gun/bullet.tscn")

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = bullet_path.global_position
		bullet_instance.transform.basis = bullet_path.global_transform.basis
		bullets.add_child(bullet_instance)
		
	
func _unhandled_input(event):
	#Handle camera and character rotation
	if event is InputEventMouseMotion:
		var change_v = event.relative.y*mouse_sens
		var change_h = event.relative.x*mouse_sens
		if Input.is_action_pressed("aim"):
			rotation.y += deg_to_rad(change_h)
			rotation.x += deg_to_rad(change_v)
