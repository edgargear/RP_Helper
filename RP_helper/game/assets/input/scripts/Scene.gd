extends PanelContainer

# node paths
onready var button_menu_node = get_tree().get_root().get_node("InputScreen/PopupManager/ButtonMenu")
var output_preview_path = null

# preloads
var button_pre = preload("res://game/assets/input/SceneButton.tscn")
var add_button = preload("res://game/assets/input/AddNewButton.tscn")

# variables
var current_scene_id = 1
var current_scene_dict = GlobalInfo.get_scene_dict(current_scene_id)

# popup menu variables
var current_popup_scene = null

#----------------------------------------------#
func _ready():
	# connect to signals
	output_preview_path = get_parent().get_node("EverythingElse/Display/DisplaySplit/OutputPreview")
	
	# load scene list
	load_scene_list()

#----------------------------------------------#
# load_scene list
func load_scene_list():
	# clear children
	Utility.delete_children($SceneList)
	
	# load scene list
	for i in range(len(GlobalInfo.scene_list)):
		var button = button_pre.instance()
		button.ini(GlobalInfo.scene_list[i]["scene_id"], GlobalInfo.scene_list[i]["name"], GlobalInfo.scene_list[i]["sprite"], GlobalInfo.scene_list[i]["text"])
		button.connect("enter_scene", self, "enter_scene_dealer")
		button.connect("load_popup_menu", self, "load_popup_menu")
		$SceneList.add_child(button)
	
	# add create new scene button
	var button = add_button.instance()
	button.ini("scene")
	button.connect("add_scene", self, "create_scene_dealer")
	$SceneList.add_child(button)
	
#------------------------------------------------#
# creating and entering scenes
func enter_scene_dealer(id):
	# change current scene id with current scene
	current_scene_id = id
	current_scene_dict = GlobalInfo.get_scene_dict(current_scene_id)
	
	# show the text saved on scene and set cursor position
	output_preview_path.get_node("VBoxContainer/HBoxContainer/TextEditor/TextBox").text = current_scene_dict["text"]
	output_preview_path.get_node("VBoxContainer/HBoxContainer/TextEditor/TextBox").cursor_set_column(current_scene_dict["cursor_col"])
	output_preview_path.get_node("VBoxContainer/HBoxContainer/TextEditor/TextBox").cursor_set_line(current_scene_dict["cursor_line"])
	
	# show image saved on scene
	var img = load(current_scene_dict["sprite"])
	output_preview_path.get_node("VBoxContainer/HBoxContainer/SpriteDisplay").texture = img
	
	# save game
	GlobalInfo.save_data()
	
func create_scene_dealer():
	GlobalInfo.create_scene("default")
	load_scene_list()
#--------------------------------------------------#
# saving text
func _on_TextBox_text_changed():
	var get_text = output_preview_path.get_node("VBoxContainer/HBoxContainer/TextEditor/TextBox").text
	save_text(get_text)

func save_text(text):	
	GlobalInfo.scene_list[GlobalInfo.scene_index_with_id(current_scene_id)]["text"] = text

func _on_TextBox_cursor_changed():
	# save cursor position
	GlobalInfo.scene_list[GlobalInfo.scene_index_with_id(current_scene_id)]["cursor_line"] = output_preview_path.get_node("VBoxContainer/HBoxContainer/TextEditor/TextBox").cursor_get_line()
	GlobalInfo.scene_list[GlobalInfo.scene_index_with_id(current_scene_id)]["cursor_col"] = output_preview_path.get_node("VBoxContainer/HBoxContainer/TextEditor/TextBox").cursor_get_column()

#----------------------------------------------------#
# saving sprite
func _on_SpriteGallery_display_sprite(path):
	# display sprite
	var sprite_load = load(path)
	output_preview_path.get_node("VBoxContainer/HBoxContainer/SpriteDisplay").texture = sprite_load
	
	# save the sprite
	GlobalInfo.scene_list[GlobalInfo.scene_index_with_id(current_scene_id)]["sprite"] = path

#-----------------------------------------------------#
# popup menu stuff
func load_popup_menu(id):
	current_popup_scene = id
	
	button_menu_node.connect("delete", self, "delete_scene")
	button_menu_node.show_popup(get_global_mouse_position())

# scene deletion
func delete_scene():
	# check if there is more than one scene first
	if len(GlobalInfo.scene_list) > 1:
		GlobalInfo.delete_scene(current_popup_scene)
	
	# refresh scene list
	load_scene_list()

#-----------------------------------------------------#
# saving state
func save():
	var save_dict = {"current_scene_id" : current_scene_id,
	"current_scene_dict" : current_scene_dict
	}
	return save_dict
