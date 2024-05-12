extends CharacterBody2D

signal movement
signal update_health(health)

@export var sfx_footstep: Array
@export var sfx_attack: Array
@export var sfx_damage: Array

@onready var ray_cast: RayCast2D = $RayCast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var audio_stream_player = $AudioStreamPlayer
@onready var audio_die = $AudioDie

var input: Dictionary = {"ui_up": Vector2.UP, "ui_down": Vector2.DOWN, "ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT}
var grid_size: int = 32
var direction: Vector2 = Vector2.RIGHT * grid_size
var in_move: bool = false
var death: bool = false
var enemy_movement: int = 0


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
	if death || in_move:
		return
		
	in_move = true
	$Timer.start()
	
	direction = input[dir] * grid_size
	# direcao do raycast
	ray_cast.target_position = direction
	ray_cast.force_raycast_update()
	
	if !ray_cast.is_colliding():
		_play_sound(sfx_footstep)
		
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2) # 2 segundos
		if GameController.dificuldade == 1:
			apply_damage(1)
			_move_enemy()
		
	match dir:
		"ui_right": animated_sprite.flip_h = false
		"ui_left": animated_sprite.flip_h = true

	if GameController.dificuldade == 2:
		apply_damage(1)
		_move_enemy()


func restore_hp(energia: int) -> void:
	GameController.health += energia
	update_health.emit(GameController.health)


func _punch() -> void:
	if death || in_move:
		return
		
	$Punch.global_position = global_position + direction
	$Punch/PunchCollision.disabled = false
	animated_sprite.play("attack")
	
	# TODO: tocar som aqui, apenas se acertar algo
	_play_sound(sfx_attack)
	
	await animated_sprite.animation_finished
	$Punch/PunchCollision.disabled = true
	animated_sprite.play("idle")
	
	if GameController.dificuldade == 3:
		# TODO: ou ate msm a cada 2 punbch ele aplica o dano
		apply_damage(1)
		_move_enemy()


func _move_enemy() -> void:
	enemy_movement += 1
	if enemy_movement % 2 == 0:
		movement.emit()
		enemy_movement = 0


func _on_timer_timeout():
	in_move = false


func _on_punch_body_entered(body: Node2D):
	if body.has_method("apply_damage"):
		body.apply_damage()


func apply_damage(strong: int, enemy_hit: bool = false) -> void:
	GameController.health -= strong
	update_health.emit(GameController.health)
	
	if enemy_hit:
		animated_sprite.play("damage")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
		
		_play_sound(sfx_damage)
	
	if GameController.health <= 0:
		death = true
		GameController.health = 0
		update_health.emit(GameController.health)
		audio_die.play()
		await audio_die.finished
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _play_sound(sfx: Array) -> void:
	audio_stream_player.stream = sfx[randi() % sfx.size()]
	audio_stream_player.play()
