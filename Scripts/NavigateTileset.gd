extends Navigation2D

func _ready() -> void:
	yield($Timer, "timeout")
	var new_path := get_simple_path($Pos1.position, $Pos2.position)
	print("path: ", str(new_path))
	$Line2D.points= new_path
