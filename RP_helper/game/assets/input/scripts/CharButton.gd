extends Panel

# signals
signal enter_character()
signal button_menu(id)

# identity
const button_type = "character"

# variables
var char_id = null
export var char_name = ""
export var char_folder_path = ""

var mouse_enter = false

#--------------------------------------------#
func ini(char_name_arg, char_folder_path_arg, char_id_arg):
	char_id = char_id_arg
	char_name = char_name_arg
	char_folder_path = char_folder_path_arg
	
	# show character name
	show_char_name()

#--------------------------------------------#
func show_char_name():
	$CharName.text = char_name

#--------------------------------------------#
func _on_CharButton_mouse_entered():
	mouse_enter = true

func _on_CharButton_mouse_exited():
	mouse_enter = false
	
func _input(event):
	if event is InputEventMouseButton:
		if mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_LEFT:
			emit_signal("enter_character", char_id)
		elif mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_RIGHT:
			emit_signal("button_menu", char_id)
