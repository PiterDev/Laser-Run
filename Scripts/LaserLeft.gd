extends Control


func _ready() -> void:
	var player: KinematicBody2D = owner.get_node("Player")
	$ProgressBar.max_value = player.laser_max_ammo
	$ProgressBar.value = player.laser_ammo

func _on_Player_on_ammo_used(new_ammo) -> void:
	$ProgressBar.value = new_ammo
