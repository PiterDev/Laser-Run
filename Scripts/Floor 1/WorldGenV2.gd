extends Node2D


export var noise_octaves := 1
export var noise_persistence := 2.8
export var noise_period := 5
export var noise_lacunarity := 8.38

func make_noise() -> OpenSimplexNoise:
	var noise := OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = noise_octaves
	noise.persistence = noise_persistence
	noise.period = noise_period
	noise.lacunarity = noise_lacunarity
	return noise

var ceiling_noise := make_noise()
var floor_noise := make_noise()

var max_ceiling_height := 14.0
var max_floor_height := 14.0

var collectible_generate_y_min := 21
var collectible_generate_y_max := 44

var path_string := "res://Scenes/RandomTileMaps/"
var ammo_replenish := preload("res://Scenes/AmmoReplenish.tscn")



var chunk_scene := preload("res://Scenes/Floor 1/WorldGenChunk.tscn")
var chunk_size := Vector2(120, 68)
var chunk_amount := 0 setget chunks_changed

var current_x_pos := 1920

var chunk_generate_start := Vector2(0, 21)
var chunk_generate_end := Vector2(119, 45)



func _ready() -> void:
	generate_chunks(10)


func get_num(from: int, to: int) -> int:
	return Game.random.randi_range(from, to)

func get_bool(size: int) -> bool:
	return Game.random.randi() % size == 0
			


# Util functions

func place_ammo(pos: Vector2):
	var ammo_instance = ammo_replenish.instance()
	ammo_instance.position = pos
	add_child(ammo_instance)


# Chunk logic

func chunks_changed(new_value: int) -> void:
	chunk_amount = new_value
	if chunk_amount < 10:
		generate_chunks(10-chunk_amount)

func _chunk_removed():
	chunk_amount -= 1

func generate_chunk(x_pos: int) -> PackedScene:
	var new_chunk = chunk_scene.instance()
	new_chunk.position = Vector2(x_pos, 0)
	
	# Generate the chunk
	
	# Generate the floor
	for x in range(0, chunk_size.x):
		
		
		# Making the floor
		var floor_height = ceil(floor_noise.get_noise_1d(x) * max_floor_height)
		for y in range(chunk_generate_end.y - floor_height, chunk_generate_end.y):
			new_chunk.set_cell(x, y, 0)

	# Generate the ceiling
	for x in range(0, chunk_size.x):
		
		var ceiling_height = ceil(ceiling_noise.get_noise_1d(x) * max_ceiling_height)
		for y in range(chunk_generate_start.y, chunk_generate_start.y+ceiling_height):
			new_chunk.set_cell(x, y, 0)
	add_child(new_chunk)
	new_chunk.connect("clearing", self, "_chunk_removed")
	
	# Generate collectibles
	for x in range(0, chunk_size.x):
		var should_place = get_bool(10)
		if not should_place:
			continue
		var to_place_y := get_num(collectible_generate_y_min, collectible_generate_y_max)
		print(to_place_y)
		var chosen_cell = new_chunk.get_cell(x, to_place_y)
		if chosen_cell != -1:
			continue
		var local_pos: Vector2 = new_chunk.map_to_world(Vector2(x, to_place_y))+Vector2(8,8)
		var global_pos: Vector2 = new_chunk.to_global(local_pos)
		place_ammo(global_pos)
	print(new_chunk.position)
	return new_chunk

func remove_all_chunks():
	for child in get_children():
		child.queue_free()

func generate_chunks(chunk_num: int):
	for _i in range(chunk_num):

		# Generate chunk and name it cause why not
		var made_chunk = generate_chunk(current_x_pos)
		# made_chunk.name = "Chunk " + str(chunk_amount)
		print(made_chunk.position)
		current_x_pos += 1920
	chunk_amount += chunk_num


# func _on_Button_update_worldgen() -> void:
#     remove_all_chunks()
#     ceiling_noise = make_noise()
#     floor_noise = make_noise()
#     generate_chunks(1)
#     print("done")
