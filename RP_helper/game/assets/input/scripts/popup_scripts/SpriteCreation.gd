extends PopupPanel

# characters folder path
const char_folder_path = "res://game/assets/characters/"

# check variables
var drag_sensor = false

var sprite_path_filled = false
var sprite_name_filled = false
var emote_chosen_check = false

# variables
var emote_list = {"emote_angry.png":"angry", "emote_awks.png":"awkward", "emote_grin.png":"grin", "emote_neutral.png":"neutral", "emote_sweat.png":"sweating", "emote_unamused.png":"unamused"}

var emote_button_pre = preload("res://game/assets/input/EmoteButton.tscn")

# emote chosen
var emote_sprite_chosen = null # emote sprite filename
var emote_name_chosen = null # name of emote

# sprite info
var sprite_name_chosen = null # name of sprite
var sprite_path_chosen = null # path of sprite

# current character
var current_char = null # current character chosen id
var current_char_dict = null # the dictionary with current_char as id

#--------------------------------------------------#
func _ready():
	# connect signals
	get_parent().get_parent().get_node("BGPanel/Margin/SceneAndEverythingElse/EverythingElse/SpriteGallery").connect("create_sprite", self, "show_popup")
	
#--------------------------------------------------#
# popup
func show_popup(char_id):
	# get the current character
	current_char = char_id
	current_char_dict = GlobalInfo.find_dict_with_id(current_char)
	
	# load emotes
	load_emotes()
	
	# show popup
	popup()

func _on_Cancel_pressed():
	hide()

func _on_Create_pressed():
	# get info from the line edits
	sprite_path_chosen = $PanelContainer/HBoxContainer/SpriteUpload/VBoxContainer/PanelContainer/VBoxContainer/SpritePath.text
	
	# check if sprite exists
	var dir = Directory.new()
	var file_exists = dir.file_exists(sprite_path_chosen)
	if file_exists:
		sprite_path_filled = true
	
	sprite_name_chosen = $PanelContainer/HBoxContainer/SpriteUpload/VBoxContainer/PanelContainer/VBoxContainer/SpriteName.text
	if sprite_name_chosen != "": # check if the name is empty
		sprite_name_filled = true
	
	# if all the fields have been filled
	if sprite_path_filled and sprite_name_filled and emote_chosen_check:
		
		# copy the sprite into character folder
		var sprite_filename = sprite_path_chosen.get_file()
		print(sprite_filename)
		dir.copy(sprite_path_chosen, str(char_folder_path, current_char_dict["char_name"], "/", sprite_filename))
		sprite_path_chosen = str(char_folder_path, current_char_dict["char_name"], "/", sprite_filename)
		
		# sends all information to GlobalInfo.gd
		GlobalInfo.add_sprite(current_char, sprite_name_chosen, sprite_path_chosen, emote_name_chosen, emote_sprite_chosen)
		
		# refresh checks
		$PanelContainer/HBoxContainer/SpriteUpload/VBoxContainer/PanelContainer/VBoxContainer/SpriteName.clear()
		$PanelContainer/HBoxContainer/SpriteUpload/VBoxContainer/PanelContainer/VBoxContainer/SpritePath.clear()
		sprite_path_filled = false
		sprite_name_filled = false
		emote_chosen_check = false
		
		# refresh sprite name and path
		sprite_name_chosen = null
		sprite_path_chosen = null
		
		# refresh emote chosen
		for _i in $PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_children():
			if $PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_node(str(_i)).sprite_name == emote_sprite_chosen:
				$PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_node(str(_i)).unselected_outline()
		
		emote_sprite_chosen = null
		emote_name_chosen = null
		
		# create new emote
		hide()
		
		# refresh sprite list
		get_parent().get_parent().get_node("BGPanel/Margin/SceneAndEverythingElse/EverythingElse/SpriteGallery").load_character_sprites(current_char)
	
		
#--------------------------------------------------#
# emote list
func load_emotes():
	# clear emote list
	Utility.delete_children($PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList)
	
	# get the emotes and their names/paths
	var emote_path = "res://game/assets/input/sprites/emote_list/"
	
	var sprite_list = Utility.get_all_files(emote_path)
	
	
	for i in range(len(sprite_list)):
		var emote_button = emote_button_pre.instance()
		emote_button.ini(sprite_list[i], emote_list[sprite_list[i]])
		emote_button.connect("emote_chosen", self, "emote_selected")
		
		$PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.add_child(emote_button)
		
# emote chosen
func emote_selected(sprite_name, emote_name):
	# unselect the previous selection
	if emote_name_chosen != null:
		# loop through all children until the sprite_name matches
		for _i in $PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_children():
			if $PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_node(str(_i)).sprite_name == emote_sprite_chosen:
				$PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_node(str(_i)).unselected_outline()
	
	# update the chosen sprite name
	emote_sprite_chosen = sprite_name
	emote_name_chosen = emote_name
	
	for _i in $PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_children():
		
		if $PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_node(str(_i)).sprite_name == emote_sprite_chosen:
			$PanelContainer/HBoxContainer/EmoteChoose/VBoxContainer/EmoteList.get_node(str(_i)).selected_outline()
			
	# activate check that an emote has been selected
	emote_chosen_check = true
#--------------------------------------------------#


