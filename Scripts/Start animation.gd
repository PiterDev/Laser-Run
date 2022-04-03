extends Node

var started := false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if started: return
	var is_stable_x := is_zero_approx($RigidBody2D.linear_velocity.x)
	var is_stable_y := is_zero_approx($RigidBody2D.linear_velocity.y)
	if is_stable_x and is_stable_y:
		started = true
		$StartGame.play("Startup")
