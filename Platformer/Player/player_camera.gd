extends Camera2D

@export var background_image : Sprite2D
@export var player = CharacterBody2D

#Camera script to make sure camera does not go beyond the scope of the background
#Requires a player object and sprite object to be provided
func _physics_process(_delta):
	if player.position.y <= background_image.position.y - background_image.texture.get_height()/2 + ProjectSettings.get_setting("display/window/size/viewport_height")/zoom.y/2:
		position.y = background_image.position.y - background_image.texture.get_height()/2 + ProjectSettings.get_setting("display/window/size/viewport_height")/zoom.y/2
	else:
		position.y = player.position.y
	position.x = player.position.x

