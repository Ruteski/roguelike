extends StaticBody2D

var resistence : int = 4
var index_anim : int
var wall       : Array = [ "01", "02", "03", "04", "05", "06" ]
var time_effect: float = 0.25


func _ready() -> void:
	randomize()
	index_anim = randi() % wall.size()
	$sprite_idle.play(wall[index_anim])
	$sprite_damage.play(wall[index_anim])


func apply_damage() -> void:
	resistence -= 1
	
	_create_effect()
	await get_tree().create_timer(time_effect).timeout
	
	if resistence <= 0:
		queue_free()
	elif resistence == 2:		
		$sprite_idle.hide()
		$sprite_damage.show()
		
	
func _create_effect() -> void:
	var effect: Tween = create_tween()
	effect.tween_property(self, 'scale', Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	effect.tween_property(self, 'scale', Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	
	
