extends Control

# signals
signal enter_scene(id)
signal load_popup_menu(id)

# identity
const button_type = "scene"

# variables
var scene_id = null
var scene_name = null
var sprite_path = null
var text_path = null

var mouse_enter = false

#--------------------------------------------#
func ini(scene_id_arg, scene_name_arg, sprite_path_arg, text_path_arg):
	scene_id = scene_id_arg
	scene_name = scene_name_arg
	sprite_path = sprite_path_arg
	text_path = text_path_arg
	
	# load everything
	load_scene_name()

#--------------------------------------------#
func load_scene_name():
	$SceneName.text = scene_name

#--------------------------------------------#
func _on_SceneButton_mouse_entered():
	mouse_enter = true

func _on_SceneButton_mouse_exited():
	mouse_enter = false

func _input(event):
	if event is InputEventMouseButton:
		if mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_LEFT:
			emit_signal("enter_scene", scene_id)
		elif mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_RIGHT:
			emit_signal("load_popup_menu", scene_id)
			
