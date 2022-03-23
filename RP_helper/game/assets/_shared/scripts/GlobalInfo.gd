extends Node


# counter variables
var char_num = 1

# character information and sprite storage info
const SAVE_PATH = "res://saves/save_file.json"
const char_folder_path = "res://game/assets/characters/"

# structure {char_id: , char_name: , char_folder_path: , sprite_list:[{"sprite_name": , "sprite_path": , "emote_name": , "emote_path"}]}
# "sprite_name" is the name given by the player
# "sprite_path" is the name of the sprite file (e.g. innkeep.png)
# "sprite_emote" is the emote sprite chosen (e.g. emote_awks.png)
var char_folders = []


# scene lists
var scene_gen = 2
var scene_list = [{"scene_id":1, "name":"default", "sprite":"", "text":"", "cursor_line":0, "cursor_col":0}]

#--------------------------------------------#
# saving and loading data
func save_data():
	# get all save data
	var nodes_to_save = get_tree().get_nodes_in_group('Persistent')
	
	var save_dict = {}
	
	save_dict["autoload_data"] = {
		"char_folders" : char_folders,
		"char_num" : char_num,
		"scene_list" : scene_list,
		"scene_gen" : scene_gen
	}
	
	for node in nodes_to_save:
		save_dict["Persistent"] = {}
		save_dict["Persistent"][node.get_path()] = node.save()
	
	# create a file
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	# serialise data dictionary to json and save
	save_file.store_line(to_json(save_dict))
	save_file.close()
	
func load_data():
	# try to load save data
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return
	
	# parse file data from json
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = parse_json(save_file.get_as_text())
	
	# load data in autoload
	char_folders = data["autoload_data"]["char_folders"]
	char_num = data["autoload_data"]["char_num"]
	scene_list = data["autoload_data"]["scene_list"]
	scene_gen = data["autoload_data"]["scene_gen"]
	
	# load data in persistent nodes
	for node_path in data["Persistent"].keys():
		var node = get_node(node_path)
		
		for attribute in data["Persistent"][node_path]:
			if attribute == "current_char":
				node.current_char = data["Persistent"][node_path][attribute]
			elif attribute == "current_scene_id":
				node.current_scene_id = data["Persistent"][node_path][attribute]
			elif attribute == "current_scene_dict":
				node.current_scene_dict = data["Persistent"][node_path][attribute]
	

func _ready():
	load_data()

#--------------------------------------------#
# return full list
func get_folders():
	return char_folders

#--------------------------------------------#
# add a character
func add_character(char_name):
	# create a new dictionary
	var char_dict = {}
	
	char_dict["char_id"] = char_num
	char_dict["char_name"] = char_name
	char_dict["char_folder_path"] = str(char_folder_path, char_name)
	
	char_dict["sprite_list"] = []
	
	# plus 1 to update id
	char_num += 1
	
	# add character to roster
	char_folders.append(char_dict)
	
	# create the folder in the character folder
	var dir = Directory.new()
	dir.open(char_folder_path)
	dir.make_dir(char_name)

func delete_character(id):
	# delete from directory
	var delete_char = find_dict_with_id(id)
	Utility.delete_directory(delete_char["char_folder_path"])
	
	# delete from the list
	char_folders.erase(delete_char)

#--------------------------------------------#
# add sprites
func add_sprite(char_id, sprite_name, sprite_path, emote_name, emote_path):
	var ind = index_with_id(char_id)
	
	# add a sprite
	var new_sprite = {}
	
	new_sprite["sprite_name"] = sprite_name
	new_sprite["sprite_path"] = sprite_path
	new_sprite["emote_name"] = emote_name
	new_sprite["emote_path"] = emote_path
	
	input_sprite(ind, new_sprite)

# putting in a sprite for character
func input_sprite(char_index, sprite):
	char_folders[char_index]["sprite_list"].append(sprite)
	
# removing a sprite from character with path
func remove_sprite(char_id, sprite_path):
	# get character index
	var char_index = index_with_id(char_id)
	
	# find sprite index
	var chosen_list = char_folders[char_index]["sprite_list"]
	var sprite_ind = null
	
	for i in range(len(chosen_list)):
		if chosen_list[i]["sprite_path"] == sprite_path:
			sprite_ind = i
	
	# remove the sprite with that index
	char_folders[char_index]["sprite_list"].remove(sprite_ind)
	
	# remove the sprite from the folder
	Utility.delete_file(sprite_path)
	
#--------------------------------------------#
# find a character dict
func find_dict_with_id(id):
	for i in range(len(char_folders)):
		if char_folders[i]["char_id"] == id:
			return char_folders[i]

# get index of dict with id
func index_with_id(id):
	for i in range(len(char_folders)):
		if char_folders[i]["char_id"] == id:
			return i

#------------------------------------#
#			SCENE MANAGEMENT		 #
#------------------------------------#

#---------------------------------------#
# scene creation
func create_scene(name):
	var new_scene = {}
	
	# scene id
	new_scene["scene_id"] = scene_gen
	scene_gen += 1
	
	new_scene["name"] = name
	new_scene["sprite"] = ""
	new_scene["text"] = ""
	
	# saving cursor position
	new_scene["cursor_line"] = 0
	new_scene["cursor_col"] = 0
	
	scene_list.append(new_scene)
	
#----------------------------------------#
# scene deletion
func delete_scene(id):
	var deletion_index = scene_index_with_id(id)
	scene_list.remove(deletion_index)
	
#-----------------------------------------#
# searching for scene with particular id and returning the index
func scene_index_with_id(id):
	for i in range(len(scene_list)):
		if scene_list[i]["scene_id"] == id:
			return i

func get_scene_dict(id):
	for i in range(len(scene_list)):
		if scene_list[i]["scene_id"] == id:
			return scene_list[i]
