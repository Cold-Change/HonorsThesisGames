extends Sprite2D

@export var item_type : String
@onready var init_position = position
@onready var position_shift = 0

@onready var child_1 : Sprite2D
@onready var child_2 : Sprite2D

@onready var parallax_position = [1,0,2]

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
	if parallax_position[0] == 1:
		if Globals.player_position.x - position.x > texture.get_width():
			shiftParallax("Right")
		elif Globals.player_position.x - position.x < -texture.get_width():
			shiftParallax("Left")
	elif parallax_position[1] == 1:
		if Globals.player_position.x - position.x - child_1.position.x > texture.get_width():
			shiftParallax("Right")
		elif Globals.player_position.x - position.x - child_1.position.x < -texture.get_width():
			shiftParallax("Left")
	elif parallax_position[2] == 1:
		if Globals.player_position.x - position.x - child_2.position.x > texture.get_width():
			shiftParallax("Right")
		elif Globals.player_position.x - position.x - child_2.position.x < -texture.get_width():
			shiftParallax("Left")
	
	if item_type == "Fast3":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[0]
	elif item_type == "Fast2":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[1]
	elif item_type == "Fast1":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[2]
	elif item_type == "Medium3":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[3]
	elif item_type == "Medium2":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[4]
	elif item_type == "Medium1":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[5]
	elif item_type == "Slow3":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[6]
	elif item_type == "Slow2":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[7]
	elif item_type == "Slow1":
		position.x = init_position.x + position_shift + (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[8]
	else:
		position.x = Globals.player_position.x - texture.get_width()/2

func shiftParallax(direction):
	if direction == "Left":
		if parallax_position == [1,0,2]:
			child_2.position.x -= texture.get_width()*3
			parallax_position == [2,1,0]
		elif parallax_position == [2,1,0]:
			child_1.position.x += texture.get_width()*3
			child_2.position.x += texture.get_width()*3
			position.x -= texture.get_width()*3
			parallax_position == [0,2,1]
		elif parallax_position == [0,2,1]:
			child_1.position.x -= texture.get_width()*3
			parallax_position == [1,0,2]
	else:
		if parallax_position == [1,0,2]:
			child_1.position.x += texture.get_width()*3
			parallax_position = [0,2,1]
		elif parallax_position == [2,1,0]:
			child_2.position.x += texture.get_width()*3
			parallax_position = [1,0,2]
		elif parallax_position == [0,2,1]:
			child_1.position.x -= texture.get_width()*3
			child_2.position.x -= texture.get_width()*3
			position.x += texture.get_width()*3
			position_shift += texture.get_width()*3
			parallax_position = [2,1,0]

