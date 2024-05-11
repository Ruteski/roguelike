extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite 

var outer_wall: Array = ["01", "02", "03"]

func _ready() -> void:
	randomize()
	var outer_wall_temp: int = randi() % outer_wall.size()
	animated_sprite.play(outer_wall[outer_wall_temp])
