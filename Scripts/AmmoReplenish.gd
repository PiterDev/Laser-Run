extends Node2D

var picked_up := false

func randomize_sound():
	$PickUpSound.pitch_scale = Game.random.randf_range(0.8, 1.2)


func _on_Area_body_entered(body: Node) -> void:
	if not body.is_in_group("Player") or picked_up: return
	picked_up = true
	Game.emit_signal("pickup")
	Game.player.laser_ammo += clamp(5, 0, Game.player.laser_max_ammo - Game.player.laser_ammo)
	Game.emit_signal("ammo_changed", Game.player.laser_ammo)
	print("Ammo changed to: " + str(Game.player.laser_ammo))
	$AnimationPlayer.play("Die")
	randomize_sound()
	$PickUpSound.play()
	


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	print("Picked up")
	
	queue_free()
	pass
