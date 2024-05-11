extends Control

@onready var player: CharacterBody2D = GameController.player


func _ready() -> void:
	$txt_health.text = str("HEALTH: ", GameController.health)
	player.update_health.connect(_on_update_health)
	
	
func _on_update_health(health: int) -> void:
	$txt_health.text = str("HEALTH: ", health)
