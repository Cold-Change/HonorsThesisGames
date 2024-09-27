extends Node2D

@onready var player = $Player
@onready var ui = $UI
var lives = 3

var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready():
	for i in range(lives):
		var poly = Polygon2D.new()
		poly.set_polygon(player.get_node("Polygon2D").get_polygon())
		poly.position = Vector2(30 + 30 * i,window_height - 30)
		poly.name = "Life" + str(i+1)
		ui.add_child(poly)

func _process(delta):
	if player.position.x < 0:
		player.position.x = window_width
	elif player.position.x > window_width:
		player.position.x = 0
	if player.position.y < 0:
		player.position.y = window_height
	elif player.position.y > window_height:
		player.position.y = 0
