extends TileMap

# 24, 14
# thx to https://www.youtube.com/watch?v=weOC_zpB5kA
export var min_width := 0
export var max_width := 1000
export var max_height := 14
var openSimplexNoise := OpenSimplexNoise.new()

export var floorgen_y_min := 10
export var floorgen_y_max := 18

export var ceilgen_y_min := -8
export var ceilgen_y_max := -5

export var player_pos := Vector2.ZERO

var random_rooms = []

var path_string := "res://Scenes/RandomTileMaps/"
var ammo_replenish = preload("res://Scenes/AmmoReplenish.tscn")


var last_gen_x := -1


func clear_range(x_start, y_start, x_end, y_end):
	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			set_cell(x,y, -1)

func load_map(pos: Vector2, map):
	var cells: Array = map.get_used_cells_by_id(0) 
	for cell in cells:
		var cell_pos: Vector2 = pos + cell
		set_cell(int(cell_pos.x), int(cell_pos.y), 0)
	map.queue_free()
	print("loaded")
	
func add_random_map(x_pos):
		var chosen_scene = random_rooms[int(rand_range(0, len(random_rooms)-1))]
#		print(load_map(Vector2.ZERO, chosen_scene))
		
		
		
		var new_instance = chosen_scene.instance()

		new_instance.position = (Vector2(-1000,-1000))
		new_instance.visible = false
		
		add_child(new_instance)
		print(x_pos)
		load_map(Vector2(x_pos, 0), new_instance)
func _process(_delta: float) -> void:
	
	var current_cell : =  world_to_map(player_pos)
	if int(current_cell.x) % 500 == 0:
		clear_range(min_width, 0, min_width+500, -1)
#		print("cleared")
	
			
func _ready() -> void:
	randomize()
	
	for i in range(1, 9):
		var current_path = path_string + str(i) + ".tscn"
		random_rooms.append(load(current_path))
	# Loading rooms

	
	openSimplexNoise.seed = randi()
	openSimplexNoise.octaves = 1
	openSimplexNoise.persistence = 0.85
	openSimplexNoise.period = 0.80
	openSimplexNoise.lacunarity = 0.75

	generate_map()
	make_playable()


# func place_speed(pos: Vector2):
# 	# if get_cell(pos.x, pos.y) != -1: return
# 	print("Run")
	
# 	var ammo_instance = ammo_replenish.instance()
# 	ammo_instance.position = pos
# 	add_child(ammo_instance) 


func generate_map() -> void:
	
	
	for x in range(min_width, max_width):
		
		#place_speed(Vector2(x, 20))

		
		
		var map_gen_rand_num := int(rand_range(1, 3))
		if x % 48 == 0 and map_gen_rand_num == 1 and x != 0 and last_gen_x != x:
			print("Generating on ", x)
			add_random_map(x)
			last_gen_x = x

		
		# floor
		for y in range(floorgen_y_min, floorgen_y_max+1):
			var rand := floor(openSimplexNoise.get_noise_2d(x,y))
			if get_cell(x, y-1) == 0:
				rand = 0
# warning-ignore:narrowing_conversion
			set_cell(x,y, rand)
			

			var place_speedup := true if get_cell(x, y) == 0 and get_cell(x, y-1) == -1 else false
			var rand_check := true if int(rand_range(1, 10)) == 1 else false
			
			if place_speedup and rand_check:
#				print("ayo")
				#place_speed(map_to_world(Vector2(x, y-1)) + Vector2(8,4))
				pass
					
		for y2 in range(ceilgen_y_max,ceilgen_y_min-1, -1):
			
			var rand := floor(openSimplexNoise.get_noise_2d(x,y2))
			if get_cell(x, y2+1) == 0:
				rand = 0
#			elif get_cell(x, y2+1) == -1:
#				rand = -1
# warning-ignore:narrowing_conversion
			set_cell(x,y2, rand)
			
			
	fill_ceil()
	fill_floor()
	min_width += max_width+1
	max_width += 1000

	
func fill_floor() -> void:
	for y in range(floorgen_y_max+1, floorgen_y_max+6):
		for x in range(min_width, max_width):
			set_cell(x, y, 0)

func fill_ceil() -> void:
	for y in range(ceilgen_y_max-3, ceilgen_y_max-10, -1):
		for x in range(min_width, max_width):
			set_cell(x, y, 0)

func make_playable() -> void:
	for x in range(min_width, max_width):
		 set_cell(x,max_height-1, 0)
	
