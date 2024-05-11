extends CharacterBody2D

var direction : Vector2
var grid_size : int = GameController.grid_size
var animator  : AnimatedSprite2D
var strong    : int = 5
var health    : int = 2

@onready var raycast: RayCast2D = $raycast
@onready var target : CharacterBody2D = GameController.player


func _ready() -> void:
	randomize()
	animator = $enemy_01 if randi_range(0, 1) == 0 else $enemy_02
	animator.visible = true
	target.movement.connect(_move)
	
	
func _move() -> void:
	animator.flip_h = false if target.global_position.x < global_position.x else true
	
	await get_tree().create_timer(0.2).timeout
	var dir: Vector2
	if abs(target.global_position.x - global_position.x) == 0:
		dir = Vector2.DOWN if target.global_position.y > global_position.y else Vector2.UP
	else:
		dir = Vector2.RIGHT if target.global_position.x > global_position.x else Vector2.LEFT
		
	direction = dir * grid_size
	raycast.target_position = direction
	raycast.force_raycast_update()
	
	if not raycast.is_colliding():
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2)
	else:
		var collision = raycast.get_collider()
		if collision.name == "player":
			_attack()
	
	
func _attack() -> void:	
	target.apply_damage(strong, true)
	animator.play("attack")
	await animator.animation_finished
	animator.play("idle")
	
	
func apply_damage() -> void:
	health -= 1
	animator.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	animator.modulate = Color.WHITE
	
	if health <= 0:	queue_free()
	
