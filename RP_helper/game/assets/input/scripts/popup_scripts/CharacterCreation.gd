extends PopupPanel

#--------------------------------------------------#
func _ready():
	get_parent().get_parent().get_node("BGPanel/Margin/SceneAndEverythingElse/EverythingElse/Character").connect("create_character", self, "show_popup")

#--------------------------------------------------#
func show_popup():
	# show popup
	popup()
	$PanelContainer/VBoxContainer/NameEnter.grab_focus()

func _on_NameEnter_text_entered(new_text):
	# create character
	get_parent().get_parent().get_node("BGPanel/Margin/SceneAndEverythingElse/EverythingElse/Character").create_character(new_text)
	
	# clear and hide popup
	$PanelContainer/VBoxContainer/NameEnter.clear()
	hide()
