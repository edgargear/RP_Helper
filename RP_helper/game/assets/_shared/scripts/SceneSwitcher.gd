extends Node

var current_scene = null
var root = null

#####################################
# variables to carry between scenes #
#####################################

# daughter id to carry between scenes
var daug_interaction_id = null

#####################################

# for pause scene
var is_paused = false
#var pause_scene = ResourceLoader.load("res://scenes/menu/Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
# goto scene but defer current scene just in case some code from current scene is still running
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path) # using call_defered, the second function will only run once all code from current scene is done

func _deferred_goto_scene(path):
	# it is now safe remove current scene
	current_scene.free()
	
	# Load new scene
	var s = ResourceLoader.load(path)
	
	# Instance the new SceneState
	current_scene = s.instance()
	
	# add to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with SceneTree.change_scene() API
	get_tree().set_current_scene(current_scene)

#############################################
# pause menu scene
#func _input(event):
#	if event.is_action_pressed("ui_esc"):
#		root = get_tree().get_root()
#		current_scene = root.get_child(root.get_child_count() - 1)
#		if is_paused == false:
#			is_paused = true
#			var canvas = CanvasLayer.new()
#			canvas.add_child(pause_scene.instance())
#			current_scene.add_child(canvas)
#		else:
#			is_paused = false
#			current_scene.remove_child(current_scene.get_child(current_scene.get_child_count() - 1))
