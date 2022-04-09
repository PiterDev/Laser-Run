extends Node

#func goto_scene(path) -> void:
#	var loader = ResourceLoader.load_interactive(path)
#	while true:
#		var err = loader.poll()
#		if err == ERR_FILE_EOF:
#			# Complete
#			var resource = loader.get_resource()
#			get_tree().get_root().call_deferred("add_child", resource.instance())
#			break
#		if err == OK:
#			# Still loading
#			var progress = float(loader.get_stage()/loader.get_stage_count())
#			print(progress)
