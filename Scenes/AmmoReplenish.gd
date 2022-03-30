extends Node2D

var picked_up := false




func _on_Area_body_entered(body: Node) -> void:
	if not body.is_in_group("Player") or picked_up: return
	picked_up = true
	body.laser_ammo = body.laser_max_ammo
	print("Death")
	$AnimationPlayer.play("Die")
	


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
