extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision: CollisionShape2D = $Collision
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var sfx_soda: Array
@export var sfx_apple: Array

var energy := 4
var food_temp: int
var food := ["soda", "apple"]


func _ready() -> void:
	randomize()
	food_temp = randi() % food.size()
	animated_sprite.play(food[food_temp])
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.name.match("Player"):
		body.restore_hp(energy)
		collision.queue_free()
		_play_sound()
		
		# aumentar o tamanho
		var tween: Tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.2, .2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		
		# ficar transparente - modulate alpha
		tween.tween_property(animated_sprite, "modulate:a", 0, .1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).set_delay(.1)
		
		# espera o tween terminar para entao deletar o objeto da tree
		await tween.finished
		queue_free()


func _play_sound() -> void:
	match food_temp:
		0: audio_stream_player.stream = sfx_soda[randi() % sfx_soda.size()]
		1: audio_stream_player.stream = sfx_apple[randi() % sfx_apple.size()]
	
	audio_stream_player.play()
