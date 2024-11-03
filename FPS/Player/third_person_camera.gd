extends Node3D

var progression_speed = 3
@onready var camera = $Path3D/PathFollow3D/Camera
@onready var ray_cast_3d = $Path3D/PathFollow3D/Camera/RayCast3D
@onready var ray_cast_3d_2 = $Path3D/PathFollow3D/Camera/RayCast3D2
@onready var path_follow_3d = $Path3D/PathFollow3D

func _process(delta):
	if ray_cast_3d.is_colliding() and path_follow_3d.progress_ratio + progression_speed*delta < 1:
		path_follow_3d.progress_ratio += progression_speed*delta
	elif ray_cast_3d.is_colliding() and path_follow_3d.progress_ratio + progression_speed*delta >= 1:
		path_follow_3d.progress_ratio = 1
	elif !ray_cast_3d_2.is_colliding():
		if path_follow_3d.progress_ratio - progression_speed*delta > 0:
			path_follow_3d.progress_ratio -= progression_speed*delta
		else:
			path_follow_3d.progress_ratio = 0
