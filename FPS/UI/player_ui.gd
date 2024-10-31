extends Control

@onready var health_bar = $HealthBar

func updateHealthBar(health):
	health_bar.value = health
