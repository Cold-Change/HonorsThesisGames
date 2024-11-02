extends Node3D

@onready var skeleton_3d = $Armature/Skeleton3D

var chest
var spine

func _ready():
	chest = skeleton_3d.find_bone("Chest")
	spine = skeleton_3d.find_bone("Spine")

func getChestRot():
	return skeleton_3d.get_bone_pose_rotation(chest)

func getSpineRot():
	return skeleton_3d.get_bone_pose_rotation(spine)

func updateChestRot(amount):
	skeleton_3d.set_bone_pose_rotation(chest,Quaternion(clamp(getChestRot().x + amount, deg_to_rad(-20), deg_to_rad(20)),getChestRot().y,getChestRot().z,getChestRot().w))

func updateSpineRot(amount):
	skeleton_3d.set_bone_pose_rotation(spine,Quaternion(clamp(getSpineRot().x + amount, deg_to_rad(-20), deg_to_rad(20)),getSpineRot().y,getSpineRot().z,getSpineRot().w))
