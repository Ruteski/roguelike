extends Area2D


func _on_body_entered(body: Node2D):
	if body.name.match("Player"):
		$Collision.queue_free()
		GameController.level += 1
		
		# timer de 1 segundo
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
