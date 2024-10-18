extends Sprite2D

@export var item_type : String
@export var mobile_speed : String
@export var mobile_const = 150
@onready var init_position = position
@onready var position_shift = 0

@onready var child_1 : Sprite2D
@onready var child_2 : Sprite2D

@onready var parallax_position = [1,0,2]

#const SPEEDS = {"Fast3":.3,"Fast2":.2,"Fast1":.1,"Medium3":.08,"Medium2":.05,"Medium1":.03,"Slow3":.01,"Slow2":.005,"Slow1":.001}
#const MOBILE_SPEEDS = {"Fast":.3,"Medium":.2,"Slow":.1}
const SPEEDS = {"Fast3":.1,"Fast2":.2,"Fast1":.3,"Medium3":.4,"Medium2":.5,"Medium1":.6,"Slow3":.7,"Slow2":.8,"Slow1":.9}
const MOBILE_SPEEDS = {"Fast":.1,"Medium":.2,"Slow":.3}

func _ready():
	#If the object is not static, create a duplicate image to the left and right
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

func _physics_process(delta):
	#Apply parallax or static
	if child_1:
		checkParallax()
		applyParallax()
	elif item_type == "Static":
		applyStatic()
	
	#Apply mobile
	if mobile_speed:
		applyMobile(delta)

#Checks for player position and shifts the parallax left or right accordingly
func checkParallax():
	if parallax_position[0] == 1:
		if Globals.player_position.x - position.x > texture.get_width():
			shiftParallax("Right")
		elif Globals.player_position.x - position.x < 0:
			shiftParallax("Left")
	elif parallax_position[1] == 1:
		if Globals.player_position.x - position.x - child_1.position.x > texture.get_width():
			shiftParallax("Right")
		elif Globals.player_position.x - position.x - child_1.position.x < 0:
			shiftParallax("Left")
	elif parallax_position[2] == 1:
		if Globals.player_position.x - position.x - child_2.position.x > texture.get_width():
			shiftParallax("Right")
		elif Globals.player_position.x - position.x - child_2.position.x < 0:
			shiftParallax("Left")

#Moves parallax background according to change of player position from player initial position
func applyParallax():
	position.x = init_position.x + position_shift - (Globals.player_init_position.x - Globals.player_position.x) * SPEEDS[item_type]

#Rotates the position of parallax item and duplicates according to the
#rotation state and the direction of the shift
func shiftParallax(direction):
	if direction == "Left":
		if parallax_position == [1,0,2]:
			child_2.position.x -= texture.get_width()*3
			parallax_position = [2,1,0]
		elif parallax_position == [2,1,0]:
			child_1.position.x += texture.get_width()*3
			child_2.position.x += texture.get_width()*3
			position.x -= texture.get_width()*3
			position_shift -= texture.get_width()*3
			parallax_position = [0,2,1]
		elif parallax_position == [0,2,1]:
			child_1.position.x -= texture.get_width()*3
			parallax_position = [1,0,2]
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

#Sticks background to player position
func applyStatic():
	position.x = Globals.player_position.x - texture.get_width()/2 + init_position.x

#Moves object according to mobile speed
func applyMobile(delta):
	position_shift -= MOBILE_SPEEDS[mobile_speed]*mobile_const*delta
