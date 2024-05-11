extends Node

var level : int = 1
var health: int = 100
var grid_size: int = 32
var player : CharacterBody2D


func restart_game() -> void:
	level = 1
	health = 100
