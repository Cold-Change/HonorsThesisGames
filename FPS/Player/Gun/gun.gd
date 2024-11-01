extends Node3D

var entity_num = -1
@onready var bullet_path = $BulletPath
@onready var bullets = $Bullets
var mouse_sens = 0.3

var bullet = load("res://Player/Gun/bullet.tscn")

@onready var npc_timer = $NPCTimer

signal emitEntityDamage(entity,damage)

func _process(_delta):
	if Input.is_action_just_pressed("shoot") and entity_num == 1:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = bullet_path.global_position
		bullet_instance.transform.basis = bullet_path.global_transform.basis
		bullet_instance.entityTakeDamage.connect(entityTakeDamage)
		bullets.add_child(bullet_instance)

func entityTakeDamage(entity,damage):
	emitEntityDamage.emit(entity,damage)

func startNPCTimer():
	if entity_num > 4:
		npc_timer.start()

func _on_npc_timer_timeout():
	if entity_num > 4:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = bullet_path.global_position
		bullet_instance.transform.basis = bullet_path.global_transform.basis
		bullet_instance.entityTakeDamage.connect(entityTakeDamage)
		bullets.add_child(bullet_instance)
