extends Node2D

@export var floor_tile : PackedScene
@export var outer_wall_tile : PackedScene
@export var wall_tile : PackedScene
@export var food_tile : PackedScene
@export var exit_tile : PackedScene
@export var enemy_tile: PackedScene

var column := 8
var rowns  := 8
var space  := 32
var grid_position := []
var wall_count = Count.new(5, 9)
var food_count = Count.new(1, 5)


func _ready() -> void:
	randomize()


func _initialize_list() -> void:
	grid_position.clear()
	for x in column - 1:
		for y in rowns - 1:
			grid_position.append(Vector2(x * space, y * space))
			
		
func _board_setup() -> void:
	for x in range(-1, column + 1):
		for y in range(-1, rowns + 1):
			var temp = outer_wall_tile.instantiate() if x == -1 || x == column || y == -1 || y == column else floor_tile.instantiate()				
			temp.global_position = Vector2(x * space, y * space)
			add_child(temp)
			
			

func _random_position() -> Vector2:
	var random = randi_range(0, grid_position.size() - 1)
	var random_pos = grid_position[random]
	grid_position.pop_at(random)
	return random_pos
			

func _spawn_object_random(tile: PackedScene, minimum: int, maximum: int) -> void:
	var object_cout = randi_range(minimum, maximum)
	for i in object_cout:
		var tile_choice = tile.instantiate() as Node2D
		tile_choice.global_position = _random_position()
		add_child(tile_choice)
		
		
func _spawn_exit() -> void:
	var temp_exit = exit_tile.instantiate() as Node2D
	temp_exit.global_position = Vector2(column * space - space, rowns - space / 4)
	add_child(temp_exit)


func setup_scene(level: int) -> void:
	_initialize_list()
	_board_setup()
	
	var enemy_count = log(GameController.level)
	_spawn_object_random(enemy_tile, enemy_count, enemy_count)
	_spawn_object_random(wall_tile, wall_count.minimum, wall_count.maximum)
	_spawn_object_random(food_tile, food_count.minimum, food_count.maximum)
	_spawn_exit()


class Count:
	var minimum : int
	var maximum : int
	
	func _init(_minimum: int, _maximum: int) -> void:
		minimum = _minimum
		maximum = _maximum
	
	
	
