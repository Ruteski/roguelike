extends StaticBody2D

@onready var sprite_idle: AnimatedSprite2D = $SpriteIdle
@onready var sprite_damage: AnimatedSprite2D = $SpriteDamage

var resistence := 4
var index_anim: int
var wall := ["01","02","03","04","05","06"]


func _ready() -> void:
	randomize()
	index_anim = randi() % wall.size()
	sprite_idle.play(wall[index_anim])
	sprite_damage.play(wall[index_anim])


func apply_damage() -> void:
	await get_tree().create_timer(.15).timeout
	
	resistence -= 1
	modulate = Color.RED
	
	await get_tree().create_timer(.1).timeout 
	modulate = Color.WHITE
	
	if resistence <= 0:
		queue_free()
	elif resistence <= 2:
		sprite_idle.hide()
		sprite_damage.show()
