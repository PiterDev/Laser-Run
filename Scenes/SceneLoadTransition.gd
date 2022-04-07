extends ColorRect


func _ready() -> void:
	$GlitchSound.seek(Game.glitch_transition_pos)
	$GlitchSound.play()
	var tween: Tween = $Tween
	
	tween.interpolate_property(get_material(), 
						   "shader_param/fade", 
						   1.0, 0.0, 1, 
						   Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()



func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
