extends CharacterBody2D

signal movement
signal update_health(health)

@export var sfx_footstep : Array
@export var sfx_attack   : Array
@export var sfx_damage   : Array

var input := { "ui_up": Vector2.UP, "ui_down": Vector2.DOWN, "ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT }
var grid_size := 32
var direction := Vector2.RIGHT * grid_size
var in_move := false
var death := false
var enemy_movement : int = 0

@onready var raycast: RayCast2D = $raycast
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite
@onready var audio_stream_sfx: AudioStreamPlayer = $audio_stream_sfx


func _ready() -> void:
	randomize()
	GameController.player = self


func _input(event: InputEvent) -> void:
	for dir in input.keys():
		if event.is_action_pressed(dir):
			_move(dir)
			
	if event.is_action_pressed("ui_accept"):
		_punch()
			
			
func _move(dir: String) -> void:
	if death or in_move: return
	
	in_move = true
	$timer.start()
	
	direction = input[dir] * grid_size
	raycast.target_position = direction
	raycast.force_raycast_update()
	
	if !raycast.is_colliding():
		apply_damage()
				
		_play_sound(sfx_footstep)
		
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2)		
		
	match dir:
		"ui_right": animated_sprite.flip_h = false
		"ui_left" : animated_sprite.flip_h = true
	
	_move_enemy()
		
		
func restore_hp(energy: int) -> void:
	GameController.health += energy
	update_health.emit(GameController.health)
	
	
func apply_damage(strong: int = 1, enemy_hit: bool = false) -> void:
	GameController.health -= strong
	update_health.emit(GameController.health)
	
	if enemy_hit:
		_play_sound(sfx_damage)
		animated_sprite.play("damage")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
	
	if GameController.health <= 0:
		death = true
		GameController.health = 0
		update_health.emit(GameController.health)
		$audio_stream_die.play()
		await $audio_stream_die.finished
		get_tree().change_scene_to_file("res://scenes/end.tscn")
	

func _punch() -> void:
	if death or in_move: return
	$punch.global_position = global_position + direction
	$punch/collision.disabled = false
	animated_sprite.play("attack")
	_play_sound(sfx_attack)
	
	await animated_sprite.animation_finished
	$punch/collision.disabled = true
	animated_sprite.play("idle")
	
	_move_enemy()
	apply_damage()
	
	
	
func _move_enemy() -> void:
	enemy_movement += 1
	if enemy_movement % 2 == 0:
		movement.emit()


func _play_sound(sfx: Array) -> void:	
	audio_stream_sfx.stream = sfx[randi() % sfx.size()]
	audio_stream_sfx.play()


func _on_timer_timeout() -> void:
	in_move = false


func _on_punch_body_entered(body: Node2D) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage()
