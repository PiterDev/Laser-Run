extends TileMap

# 24, 14
# thx to https://www.youtube.com/watch?v=weOC_zpB5kA
export var min_width := 0
export var max_width := 1000
export var max_height := 14
var openSimplexNoise := OpenSimplexNoise.new()

export var floorgen_y_min := 10
export var floorgen_y_max := 13

export var ceilgen_y_min := -8
export var ceilgen_y_max := -5

export var player_pos := Vector2.ZERO

var random_rooms = []

var path_string := "res://Scenes/RandomTileMaps/"

var last_gen_x := -1


func clear_range(x_start, y_start, x_end, y_end):
	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			set_cell(x,y, -1)

func add_random_map(x_pos):
		var chosen_scene = random_rooms[rand_range(0, len(random_rooms)-1)]
		var new_instance = chosen_scene.instance()
		new_instance.position = (Vector2(x_pos,-16*3))
		new_instance.connect("exited", self, "_map_removed")
		add_child(new_instance)
		
func _process(delta: float) -> void:
	
	var current_cell : =  world_to_map(player_pos)
	if int(current_cell.x) % 500 == 0:
		clear_range(min_width, 0, min_width+500, -1)
		print("cleared")
	if (int(current_cell.x) + 48) % 24 == 0 and int(current_cell.x) > 0:
		var rand_num := int(rand_range(1, 3))
		if rand_num == 1 and last_gen_x != int(current_cell.x)+48:
			print("Generating")
			add_random_map(map_to_world(Vector2(current_cell.x+48, current_cell.y)).x)
			last_gen_x = int(current_cell.x)+48
			
func _ready() -> void:
	
	for i in range(1, 9):
		var current_path = path_string + str(i) + ".tscn"
		random_rooms.append(load(current_path))
	
	randomize()
	openSimplexNoise.seed = randi()
	openSimplexNoise.octaves = 1
	openSimplexNoise.persistence = 0.85
	openSimplexNoise.period = 0.80
	openSimplexNoise.lacunarity = 0.75
	
	generate_map()
	make_playable()
	

func generate_map() -> void:
	
	
	for x in range(min_width, max_width):
		# floor
		for y in range(floorgen_y_min, floorgen_y_max+1):
			var rand := floor(openSimplexNoise.get_noise_2d(x,y))
			if get_cell(x, y-1) == 0:
				rand = 0
			set_cell(x,y, rand)
		
		
		for y2 in range(ceilgen_y_max,ceilgen_y_min-1, -1):
			
			var rand := floor(openSimplexNoise.get_noise_2d(x,y2))
			if get_cell(x, y2+1) == 0:
				rand = 0
#			elif get_cell(x, y2+1) == -1:
#				rand = -1

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
	
