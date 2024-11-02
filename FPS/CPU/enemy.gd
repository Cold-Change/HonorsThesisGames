extends CharacterBody3D

@export var entity_num = -1
@onready var enemy_model = $EnemyModel
var health = 100.0

func _ready():
	enemy_model.updateChestRot(deg_to_rad(5)*1/2)
	enemy_model.updateSpineRot(deg_to_rad(5)*1/2)

func takeDamage(damage):
	health -= damage

func getEntity():
	return entity_num
