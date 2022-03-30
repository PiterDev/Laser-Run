extends RayCast2D

func _process(delta: float) -> void:
	cast_to.y = clamp(owner.velocity.y, 0, 3)
