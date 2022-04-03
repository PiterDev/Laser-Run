extends TileMap

signal clearing

func _on_Visible_screen_entered() -> void:
	$RemoveTimer.stop()
    

func _on_Visible_screen_exited() -> void:
	$RemoveTimer.start()


func _on_RemoveTimer_timeout() -> void:
	emit_signal("clearing")
	queue_free()
