extends StaticBody2D

@onready var sprite_idle: AnimatedSprite2D = $SpriteIdle

var resistence := 4
var index_anim: int
var wall := ["01","02","03","04","05","06"]


func _ready() -> void:
	randomize()
	index_anim = randi() % wall.size()
	sprite_idle.play(wall[index_anim])
