extends Sprite2D

@export var item_type : String
@onready var init_position = position

@onready var child_1 : Sprite2D
@onready var child_2 : Sprite2D

@onready var parallax_shift = 0

const SPEEDS = [.3,.2,.1,.08,.05,.03,.01,.005,.001]

func _ready():
	if item_type != "Static":
		var duplicate_sprite_right = Sprite2D.new()
		var duplicate_sprite_left = Sprite2D.new()
		add_child(duplicate_sprite_right)
		duplicate_sprite_right.texture = texture
		duplicate_sprite_right.position.x = texture.get_width()
		duplicate_sprite_right.name = name + "R"
		add_child(duplicate_sprite_left)
		duplicate_sprite_left.texture = texture
		duplicate_sprite_left.position.x = -texture.get_width()
		duplicate_sprite_left.name = name + "L"
		child_1 = duplicate_sprite_left
		child_2 = duplicate_sprite_right

func _physics_process(_delta):
	if abs(init_position.x) - abs(position.x) > abs(texture.get_width() * parallax_shift):
		shiftParallax("Left")
	
	if item_type == "Fast3":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[0]
	elif item_type == "Fast2":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[1]
	elif item_type == "Fast1":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[2]
	elif item_type == "Medium3":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[3]
	elif item_type == "Medium2":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[4]
	elif item_type == "Medium1":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[5]
	elif item_type == "Slow3":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[6]
	elif item_type == "Slow2":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[7]
	elif item_type == "Slow1":
		position.x = init_position.x + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[8]
	else:
		position.x = Globals.player_position.x - texture.get_width()/2

func shiftParallax(direction):
	if direction == "Left":
		child_2.position.x -= texture.get_width()*2
		parallax_shift -= 1
	else:
		child_1.position.x += texture.get_width()*2
		parallax_shift += 1
	print(parallax_shift)
