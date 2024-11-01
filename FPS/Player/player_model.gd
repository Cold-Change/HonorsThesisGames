extends Node3D

@onready var armature = $Armature
@onready var skeleton_3d = $Armature/Skeleton3D

@onready var first_person_camera = $Armature/Skeleton3D/HeadAttatchment/FirstPersonCamera
@onready var third_person_camera = $Armature/Skeleton3D/MainAttatchment/ThirdPersonCamera

@onready var animation_tree = $AnimationTree
var state_machine

var main
var head
var chest
var spine
var hip

func _ready():
	state_machine = animation_tree.get("parameters/playback")
	main = skeleton_3d.find_bone("Main")
	head = skeleton_3d.find_bone("Head")
	chest = skeleton_3d.find_bone("Chest")
	spine = skeleton_3d.find_bone("Spine")
	hip = skeleton_3d.find_bone("Hip")

func travelInStandingState(walking):
	if walking:
		state_machine.travel("WalkGun")
	else:
		state_machine.travel("StandingGun")

func travelInCrouchedState(walking):
	if walking:
		state_machine.travel("CrouchWalkGun")
	else:
		state_machine.travel("CrouchedGun")

func travelToStandingState():
	state_machine.travel("StandGun")

func travelToCrouchedState():
	state_machine.travel("CrouchGun")

func getHeadPos():
	return skeleton_3d.get_bone_pose_position(head)

func getHeadRot():
	return skeleton_3d.get_bone_pose_rotation(head)

func getMainRot():
	return skeleton_3d.get_bone_pose_rotation(main)

func getChestRot():
	return skeleton_3d.get_bone_pose_rotation(chest)

func getSpineRot():
	return skeleton_3d.get_bone_pose_rotation(spine)

func updateHeadRot(amount):
	skeleton_3d.set_bone_pose_rotation(head,Quaternion(getHeadRot().x + amount,getHeadRot().y,getHeadRot().z,getHeadRot().w))

func updateChestRot(amount):
	skeleton_3d.set_bone_pose_rotation(chest,Quaternion(clamp(getChestRot().x + amount, deg_to_rad(-20), deg_to_rad(20)),getChestRot().y,getChestRot().z,getChestRot().w))

func updateSpineRot(amount):
	skeleton_3d.set_bone_pose_rotation(spine,Quaternion(clamp(getSpineRot().x + amount, deg_to_rad(-20), deg_to_rad(20)),getSpineRot().y,getSpineRot().z,getSpineRot().w))
