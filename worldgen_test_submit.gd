extends Button

signal update_worldgen
onready var parent_node = get_parent()
func _on_Button_pressed() -> void:
	var persistence = parent_node.get_node("PersistenceSlider").value
	var octave = parent_node.get_node("OctaveSlider").value
	var period = parent_node.get_node("PeriodSlider").value
	var lacunarity = parent_node.get_node("LacunaritySlider").value

	print(octave, " " ,persistence, " " ,period, " " , lacunarity)

	var world_generator = owner.get_node("NewGenerator")
	world_generator.noise_octaves = octave
	world_generator.noise_persistence = persistence
	world_generator.noise_period = period
	world_generator.noise_lacunarity =lacunarity
	emit_signal("update_worldgen")
