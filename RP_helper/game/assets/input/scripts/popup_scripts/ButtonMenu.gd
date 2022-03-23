extends PopupMenu

# signals
signal delete

#-------------------------------#
# menu options

func _on_Delete_pressed():
	emit_signal("delete")
	hide_popup()

#-------------------------------#
# show/hide popup
func show_popup(pos):
	rect_position = pos
	popup()
	
func hide_popup():
	hide()
