extends Control

# signals
signal enter_character(path)
signal create_character
signal character_finished(path)
signal delete_character(path)

# variables
const char_folder_path = "res://game//assets//characters//"
onready var button_menu_node = get_tree().get_root().get_node("InputScreen/PopupManager/ButtonMenu")

# preloads
var char_button_pre = preload("res://game/assets/input/CharButton.tscn")
var add_new_button_pre = preload("res://game/assets/input/AddNewButton.tscn")

var current_char = null

# button hover
var button_menu_id = null

#----------------------------------------#
func _ready():
	# load character list
	load_char_list()

func return_current_char():
	return current_char

#----------------------------------------#
func load_char_list():
	# get the character folders
	var char_list = GlobalInfo.get_folders()
	
	# delete all children
	Utility.delete_children($CharacterSelection)
	
	# # connect buttons and 
	for i in range(len(char_list)):
		var button = char_button_pre.instance()
		button.ini(char_list[i]["char_name"], char_list[i]["char_folder_path"], char_list[i]["char_id"])
		button.connect("enter_character", self, "enter_character_dealer")
		button.connect("button_menu", self, "load_menu")
		$CharacterSelection.add_child(button)
	
	# add the new char button
	var button = add_new_button_pre.instance()
	button.ini("character")
	button.connect("add_char", self, "access_popup")
	$CharacterSelection.add_child(button)
	
#-------------------------------------------#
# enter character
func enter_character_dealer(id):
	# emit signal to send to sprite gallery
	emit_signal("enter_character", id)
	
	# change the current character selected
	current_char = id
	
# character creation
func access_popup():
	# popup menu to ask for name
	emit_signal("create_character")

func create_character(name):
	# create folder in the character folder
	GlobalInfo.add_character(name)
	
	# emit signal to create dictionary in SpriteGallery
	emit_signal("character_finished", str(char_folder_path, name))
	
	# refresh the character list
	load_char_list()

# delete character
func delete_character():
	# delete from directory
	GlobalInfo.delete_character(button_menu_id)
	
	# refresh list
	load_char_list()

#--------------------------------------------#
func load_menu(id):
	button_menu_id = id
	
	button_menu_node.connect("delete", self, "delete_character")
	button_menu_node.show_popup(get_global_mouse_position())
	
#--------------------------------------------#
func save():
	var save_dict = {
		"current_char" : current_char
	}
	return save_dict
