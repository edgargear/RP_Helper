extends Control

signal add_scene
signal add_char
signal add_sprite

# variables
var mouse_enter = false

var add_type = null

#-----------------------------------------------#
func ini(type):
	add_type = type

#-----------------------------------------------#
# has mouse entered area of interest
func _on_AddNewButton_mouse_entered():
	mouse_enter = true
	
func _on_AddNewButton_mouse_exited():
	mouse_enter = false

# deal with mouse
func _input(event):
	if event is InputEventMouseButton:
		if mouse_enter == true and event.is_pressed() and event.button_index == BUTTON_LEFT:
			if add_type == "scene":
				emit_signal("add_scene")
			elif add_type == "character":
				emit_signal("add_char")
			elif add_type == "sprite":
				emit_signal("add_sprite")

