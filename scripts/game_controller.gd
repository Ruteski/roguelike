extends Node

var grid_size: int = 32
var player: CharacterBody2D
var level: int = 1
var health: int = 100

# TODO: criar uma UI para alterar o nível de dificuldade
# será relacionado em quais momentos os inimigo vai se movimentar
# criar um nível 4? insano, por tempo
# tb criar uma forma de spawnar mais cura conforme aumenta o nivel
var dificuldade = 1


func restart_game() -> void:
	level = 1
	health = 100
