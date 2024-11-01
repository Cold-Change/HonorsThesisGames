extends CharacterBody3D

@export var entity_num = -1
var health = 100.0

func takeDamage(damage):
	health -= damage

func getEntity():
	return entity_num
