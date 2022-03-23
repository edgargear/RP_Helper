extends Panel

# signals
signal emote_chosen(sprite_name, emote_name)

# check variables
var mouse_enter = false

# variables
var sprite_name = null
var emote_name = null

var emote_sprite_folder = "res://game/assets/input/sprites/emote_list/"

#----------------------------- ----------#
func ini(sprite_name_arg, emote_name_arg):
	sprite_name = sprite_name_arg
	emote_name = emote_name_arg
	
	# load sprite
	load_emote_sprite()
	
func load_emote_sprite():
	var img = load(str(emote_sprite_folder, sprite_name))
	$EmoteSprite.texture = img
	
#----------------------------------------#
# mouse control
func _on_EmoteButton_mouse_entered():
	mouse_enter = true

func _on_EmoteButton_mouse_exited():
	mouse_enter = false
	
func _input(event):
	if mouse_enter == true and event.is_pressed() and event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		selected_outline()
		emit_signal("emote_chosen", sprite_name, emote_name)

func _unhandled_input(event):
	pass
	
func _unhandled_key_input(event):
	pass

#------------------------------------------#
func selected_outline():
	$Selection.show()

func unselected_outline():
	$Selection.hide()
