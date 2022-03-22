extends Node
#
#var current_pos := Vector2.ZERO
#
#var existing_maps := 1
#
#var random_rooms = []
#
#var path_string := "res://Scenes/RandomTileMaps/"
#
#func _ready():
#	randomize()
#	for i in range(1, 9):
#		var current_path = path_string + str(i) + ".tscn"
#		random_rooms.append(load(current_path))
#
#	generate_maps(2)
#
#func _map_removed(map):
#	existing_maps -= 1
#	generate_maps(2)
#
#func generate_maps(map_amount:int):
#	for i in range(map_amount):
#		current_pos += Vector2(400, 0)
#		var chosen_scene = random_rooms[rand_range(0, len(random_rooms)-1)]
#		var new_instance = chosen_scene.instance()
#		new_instance.position = current_pos
#		new_instance.connect("exited", self, "_map_removed")
#		$GeneratedMaps.add_child(new_instance)
#		existing_maps += 1
