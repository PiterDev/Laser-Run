extends TileMap

signal exited(me)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	emit_signal("exited", self)
