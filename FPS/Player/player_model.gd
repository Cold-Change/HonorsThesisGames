extends Node3D

@onready var armature = $Armature
@onready var skeleton_3d = $Armature/Skeleton3D

@onready var first_person_camera = $Armature/Skeleton3D/HeadAttatchment/FirstPersonCamera
@onready var third_person_camera = $Armature/Skeleton3D/MainAttatchment/ThirdPersonCamera

var main
var head
var chest
var spine

func _ready():
	main = skeleton_3d.find_bone("Main")
	head = skeleton_3d.find_bone("Head")
	chest = skeleton_3d.find_bone("Chest")
	spine = skeleton_3d.find_bone("Spine")

func getHeadPos():
	return skeleton_3d.get_bone_pose_position(head)

func getHeadRot():
	return skeleton_3d.get_bone_pose_rotation(head)

func getMainRot():
	return skeleton_3d.get_bone_pose_rotation(main)

func getChestRot():
	return skeleton_3d.get_bone_pose_rotation(chest)

func getSpineRot():
	return skeleton_3d.get_bone_pose_rotation(chest)

func updateHeadRot(amount):
	skeleton_3d.set_bone_pose_rotation(head,Quaternion(getHeadRot().x + amount,getHeadRot().y,getHeadRot().z,getHeadRot().w))

func updateChestRot(amount):
	skeleton_3d.set_bone_pose_rotation(chest,Quaternion(clamp(getChestRot().x + amount, deg_to_rad(-25), deg_to_rad(25)),getChestRot().y,getChestRot().z,getChestRot().w))

func updateSpineRot(amount):
	skeleton_3d.set_bone_pose_rotation(spine,Quaternion(getSpineRot().x + amount,getSpineRot().y,getSpineRot().z,getSpineRot().w))
