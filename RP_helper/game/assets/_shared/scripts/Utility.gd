extends Node

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

static func sum_array(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum

static func merge_dir(target, patch):
	for key in patch:
		target[key] = patch[key]

static func get_all_dir(path, begins_with): # get all directories in path
	var dir = Directory.new()
	var dir_list = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var dir_name = dir.get_next()
		while dir_name != "":
			if dir.current_is_dir() and dir_name.begins_with(begins_with):
				dir_list.append(dir_name)
			dir_name = dir.get_next()
	else:
		print("Error accessing path")
	
	return dir_list

func get_all_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append(file)

	dir.list_dir_end()

	return files

static func delete_directory(path):
	var dir = Directory.new()
	
	# open directory
	var error = dir.open(path)
	if error == OK:
		# list dir content
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				delete_directory(path + "/" + file_name)
			else:
				dir.remove(file_name)
			file_name = dir.get_next()
		
		# remove current path
		dir.remove(path)
	else:
		print("Error removing " + path)

static func delete_file(path):
	var dir = Directory.new()
	
	# open directory
	dir.remove(path)
