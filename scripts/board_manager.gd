extends Node2D

@export var floor_tile: PackedScene
@export var outer_wall_tile: PackedScene

var column := 8
var rows := 8
var space := 32
var grid_position := []


func _ready() -> void:
	initialize_list()
	board_setup()


func initialize_list() -> void:
	# configuracao grid
	grid_position.clear()
	for x in column - 1:
		for y in rows -1:
			grid_position.append(Vector2(x * space, y * space))
	

func board_setup() -> void:
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
