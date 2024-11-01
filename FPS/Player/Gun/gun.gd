extends Node3D

@onready var bullet_path = $BulletPath
@onready var bullets = $Bullets
var mouse_sens = 0.3

var bullet = load("res://Player/Gun/bullet.tscn")

signal emitPlayerDamage(player,damage)

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = bullet_path.global_position
		bullet_instance.transform.basis = bullet_path.global_transform.basis
		bullet_instance.playerTakeDamage.connect(playerTakeDamage)
		bullets.add_child(bullet_instance)

func playerTakeDamage(player,damage):
	emitPlayerDamage.emit(player,damage)
