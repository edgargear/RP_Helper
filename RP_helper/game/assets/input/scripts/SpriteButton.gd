extends Control

# signals
signal load_sprite(path)
signal load_menu(path)

# identity
const button_type = "sprite"

# check variables
var mouse_enter = false

# path variables
var emote_folder_path = "res://game/assets/input/sprites/emote_list/"

# other variables
var char_id = null # id for character which contains this sprite

var sprite_name = null # name of sprite
var sprite_path = null # absolute path of sprite

var emote_name = null # emote name
var emote_path = null # sprite filename 

#-------------------------------------#
func ini(char_id_arg, sprite_name_arg, sprite_path_arg, emote_name_arg, emote_path_arg):
	# initialise the button
	char_id = char_id_arg
	
	sprite_name = sprite_name_arg
	sprite_path = sprite_path_arg
	
	emote_name = emote_name_arg
	emote_path = emote_path_arg
	
	# display emote
	show_emote()
	
	# set tooltip
	hint_tooltip = str(sprite_name, "\n", emote_name)
	
#-------------------------------------#
func show_emote():
	# load emote
	var emote_img = load(str(emote_folder_path, emote_path))
	print(str(emote_folder_path, emote_path))
	$SpriteEmote.texture = emote_img

#-------------------------------------#
# mouse location checks
func _on_SpriteButton_mouse_entered():
	mouse_enter = true

func _on_SpriteButton_mouse_exited():
	mouse_enter = false

func _input(event):
	if event is InputEventMouseButton:
		if mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_LEFT:
			emit_signal("load_sprite", sprite_path)
		elif mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_RIGHT:
			emit_signal("load_menu", sprite_path)
