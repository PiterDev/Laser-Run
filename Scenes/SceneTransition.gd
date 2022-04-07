extends ColorRect

export var scene_path := "res://"

func _on_Play_pressed() -> void:
	var tween: Tween = $Tween
	
	tween.interpolate_property(get_material(), 
						   "shader_param/fade", 
						   0.0, 1.0, 1.0, 
						   Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$GlitchSound.play()


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	Game.glitch_transition_pos = $GlitchSound.get_playback_position()
	get_tree().change_scene("res://Scenes/Map.tscn")
