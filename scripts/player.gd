extends CharacterBody2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var input: Dictionary = {"ui_up": Vector2.UP, "ui_down": Vector2.DOWN, "ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT}
var direction: Vector2 = Vector2.RIGHT
var grid_size: int = 32
var in_move: bool = false
var death: bool = false


func _input(event: InputEvent) -> void:
	for dir in input.keys():
		if event.is_action_pressed(dir):
			_move(dir)


func _move(dir: String) -> void:
	if death || in_move:
		return
		
	in_move = true
	$Timer.start()
	
	direction = input[dir] * grid_size
	# direcao do raycast
	ray_cast.target_position = direction
	ray_cast.force_raycast_update()
	
	if !ray_cast.is_colliding():
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2) # 2 segundos
		
	match dir:
		"ui_right": animated_sprite.flip_h = false
		"ui_left": animated_sprite.flip_h = true


func restore_hp(amount: int) -> void:
	pass


func _on_timer_timeout():
	in_move = false
