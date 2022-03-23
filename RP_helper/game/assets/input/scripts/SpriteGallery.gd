extends PanelContainer

# signals
signal create_sprite(char_name)
signal display_sprite(path)

# preloads
var add_button_pre = preload("res://game/assets/input/AddNewButton.tscn")
var sprite_button_pre = preload("res://game/assets/input/SpriteButton.tscn")

# menu variables
onready var button_menu_node = get_tree().get_root().get_node("InputScreen/PopupManager/ButtonMenu")
var sprite_menu_path = null
var current_character_id = null

#----------------------------------------------#
func _ready():
	# connect al necessary signals
	get_parent().get_node("Character").connect("enter_character", self, "load_character_sprites")
	get_parent().get_node("Character").connect("character_finished", self, "make_char_dict")
	get_parent().get_node("Character").connect("delete_character", self, "delete_char_dict")
	
#----------------------------------------------#
# load sprite list
func load_character_sprites(id):
	# set current character
	current_character_id = id
	
	# clear everything first
	Utility.delete_children($SpriteList)
	
	var char_dict = GlobalInfo.find_dict_with_id(id)
	
	if char_dict["sprite_list"].empty():
		var button = add_button_pre.instance()
		
		button.ini("sprite")
		button.connect("add_sprite", self, "create_sprite")
		$SpriteList.add_child(button)
	else:
		for i in range(len(char_dict["sprite_list"])):
			var button = sprite_button_pre.instance()
			button.ini(id, char_dict["sprite_list"][i]["sprite_name"], char_dict["sprite_list"][i]["sprite_path"], char_dict["sprite_list"][i]["emote_name"], char_dict["sprite_list"][i]["emote_path"])
			button.connect("load_sprite", self, "display_sprite")
			button.connect("load_menu", self, "load_menu")
			$SpriteList.add_child(button)
			
		var button = add_button_pre.instance()
		button.ini("sprite") 
		button.connect("add_sprite", self, "create_sprite")
		$SpriteList.add_child(button)

# refresh sprites
func refresh_sprites():
	
	# clear everything first
	Utility.delete_children($SpriteList)
	
	var char_dict = GlobalInfo.find_dict_with_id(current_character_id)
	
	if char_dict["sprite_list"].empty():
		var button = add_button_pre.instance()
		
		button.ini("sprite")
		button.connect("add_sprite", self, "create_sprite")
		$SpriteList.add_child(button)
	else:
		for i in range(len(char_dict["sprite_list"])):
			var button = sprite_button_pre.instance()
			button.ini(current_character_id, char_dict["sprite_list"][i]["sprite_name"], char_dict["sprite_list"][i]["sprite_path"], char_dict["sprite_list"][i]["emote_name"], char_dict["sprite_list"][i]["emote_path"])
			button.connect("load_sprite", self, "display_sprite")
			button.connect("load_menu", self, "load_menu")
			$SpriteList.add_child(button)
			
		var button = add_button_pre.instance()
		button.ini("sprite") 
		button.connect("add_sprite", self, "create_sprite")
		$SpriteList.add_child(button)
#----------------------------------------------#
# make a sprite
func create_sprite():
	emit_signal("create_sprite", get_parent().get_node("Character").current_char)

# delete sprite
func delete_sprite():
	GlobalInfo.remove_sprite(current_character_id, sprite_menu_path)
	refresh_sprites()

# clear sprites
func clear_sprites():
	Utility.delete_children($SpriteList)

#------------------------------------------------#
# deal with loading sprites
func display_sprite(path):
	emit_signal("display_sprite", path)

#-------------------------------------------------#
# loading button related menu
func load_menu(path):
	sprite_menu_path = path
	
	button_menu_node.connect("delete", self, "delete_sprite")
	button_menu_node.show_popup(get_global_mouse_position())
