extends Node2D


func _ready():
	$BoardManager.setup_scene(GameController.level)
