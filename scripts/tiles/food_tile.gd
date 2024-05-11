extends Area2D

@export var sfx_soda : Array
@export var sfx_apple: Array

var energy	  : int = 4
var food_temp : int
var food	  : Array = [ "soda", "apple"]

@onready var audio_stream_player: AudioStreamPlayer = $audio_stream_player

func _ready() -> void:
	randomize()
	food_temp = randi() % food.size()
	$animated_sprite.play(food[food_temp])


func _on_body_entered(body: Node2D) -> void:
	if body.name.match("player"):
		body.restore_hp(energy)
		$collision.queue_free()
		_play_sound()
		
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.2, .5)
		tween.tween_property($animated_sprite, "modulate:a", 0, .5).set_delay(.2)
		
		await tween.finished
		queue_free()



func _play_sound() -> void:
	match food_temp:
		0: audio_stream_player.stream = sfx_soda[randi() % sfx_soda.size()]
		1: audio_stream_player.stream = sfx_apple[randi() % sfx_apple.size()]
		
	audio_stream_player.play()




