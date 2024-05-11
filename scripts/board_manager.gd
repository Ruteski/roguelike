extends Node2D

@export var floor_tile: PackedScene
@export var outer_wall_tile: PackedScene
@export var wall_tile: PackedScene

var column := 8
var rows := 8
var space := 32
var grid_position := []
var wall_count = Count.new(5,9) # quantidade de wall criados no grid - dificuldade


func _ready() -> void:
	setup_scene()

	
#grid
func _initialize_list() -> void:
	# configuracao grid
	grid_position.clear()
	for x in column - 1:
		for y in rows -1:
			grid_position.append(Vector2(x * space, y * space))
	

#walls
func _board_setup() -> void:
	for x in range(-1, column + 1):
		for y in range(-1, rows +1):
			# jeito 1 de fazer - ternario
			var temp: Node2D = outer_wall_tile.instantiate() if x == -1 || x ==  column || y == -1 || y == column  else floor_tile.instantiate() 

			# jeito 2 de fazer - jeito padrao
#			var temp: Node2D
#			if x == -1 || x ==  column || y == -1 || y == column:
#				temp = outer_wall_tile.instantiate()
#			else:
#				temp = 	floor_tile.instantiate()
			
			temp.global_position = Vector2(x * space, y * space)
			add_child(temp)

			
func _random_position()	-> Vector2:
	var random: int = randi_range(0, grid_position.size() - 1)
	var random_pos = grid_position[random]
	grid_position.erase(random)
	return random_pos
	
			
func _spawn_tile() -> void:
	var tile_count := randi_range(wall_count.min, wall_count.max)
	for i in tile_count:
		var tile: Node2D = wall_tile.instantiate()
		tile.global_position = _random_position()
		add_child(tile)
	

func setup_scene():
	_initialize_list()
	_board_setup()
	_spawn_tile()
		
			
class Count:
	var min: int
	var max: int
	
	func _init(_min: int, _max: int) -> void:
		min = _min
		max = _max
