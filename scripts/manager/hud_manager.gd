extends Control

@onready var health_txt: Label = $HealthLabel
@onready var player: CharacterBody2D = GameController.player


func _ready():
	health_txt.text = str("HEALTH: ", GameController.health)
	player.update_health.connect(_on_update_health)


func _on_update_health(health: int) -> void:
	health_txt.text = str("HEALTH: ", health)
