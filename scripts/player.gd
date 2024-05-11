extends CharacterBody2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var input: Dictionary = {"ui_up": Vector2.UP, "ui_down": Vector2.DOWN, "ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT}
var grid_size: int = 32
var direction: Vector2 = Vector2.RIGHT * grid_size
var in_move: bool = false
var death: bool = false


func _input(event: InputEvent) -> void:
	for dir in input.keys():
		if event.is_action_pressed(dir):
			_move(dir)
	
	if event.is_action_pressed("ui_accept"):
		_punch()


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


func _punch() -> void:
	if death || in_move:
		return
		
	$Punch.global_position = global_position + direction
	$Punch/PunchCollision.disabled = false
	animated_sprite.play("attack")
	
	await animated_sprite.animation_finished
	$Punch/PunchCollision.disabled = true
	animated_sprite.play("idle")


func _on_timer_timeout():
	in_move = false


func _on_punch_body_entered(body: Node2D):
	if body.has_method("apply_damage"):
		body.apply_damage()
