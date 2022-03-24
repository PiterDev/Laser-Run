extends Button



func _on_Menu_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
