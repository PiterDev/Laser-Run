extends TileMap

# 24, 14
# thx to https://www.youtube.com/watch?v=weOC_zpB5kA
export var max_width := 24 * 100
export var max_height := 14
var openSimplexNoise := OpenSimplexNoise.new()

export var floorgen_y_min := 10
export var floorgen_y_max := 13

export var ceilgen_y_min := -8
export var ceilgen_y_max := -5


func _ready() -> void:
	randomize()
	openSimplexNoise.seed = randi()
	openSimplexNoise.octaves = 1
	openSimplexNoise.persistence = 0.85
	openSimplexNoise.period = 0.80
	openSimplexNoise.lacunarity = 0.75
	generate_map()
	make_playable()

func generate_map() -> void:
	
	
	for x in max_width:
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

	
func fill_floor() -> void:
	for y in range(floorgen_y_max+1, floorgen_y_max+6):
		for x in max_width:
			set_cell(x, y, 0)

func fill_ceil() -> void:
	for y in range(ceilgen_y_max-3, ceilgen_y_max-10, -1):
		for x in max_width:
			set_cell(x, y, 0)

func make_playable() -> void:
	for x in max_width:
		 set_cell(x,max_height-1, 0)
	
