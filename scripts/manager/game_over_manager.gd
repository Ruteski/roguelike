extends CanvasLayer


func _ready():
	var msg = "Você sobreviveu por %s dia(s)." % GameController.level
	$Control/LabelMessage.text = msg


func _on_button_restart_pressed():
	GameController.restart_game()
	get_tree().change_scene_to_file("res://scenes/game_manager.tscn")


func _on_button_menu_pressed():
	GameController.restart_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
