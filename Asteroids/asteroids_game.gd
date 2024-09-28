extends Node2D

@onready var player = $Player
@onready var ui = $UI
@onready var asteroids = $Asteroids

var lives = 3

var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready():
	updateLives()
	player.receiveDamage.connect(playerIsDamaged)

func _process(delta):
	checkPosition(player)
	for asteroid in asteroids.get_children():
		checkPosition(asteroid)

func checkPosition(obj):
	if obj.position.x < 0:
		obj.position.x = window_width
	elif obj.position.x > window_width:
		obj.position.x = 0
	if obj.position.y < 0:
		obj.position.y = window_height
	elif obj.position.y > window_height:
		obj.position.y = 0

func updateLives():
	for i in ui.get_children():
		i.queue_free()
	for i in range(lives):
		var poly = Polygon2D.new()
		poly.set_polygon(player.get_node("Polygon2D").get_polygon())
		poly.position = Vector2(30 + 30 * i,window_height - 30)
		poly.name = "Life" + str(i+1)
		ui.add_child(poly)

func playerIsDamaged():
	lives -= 1
	updateLives()
