extends AnimatedSprite2D

var floor_tile := ["01","02","03","04","05","06","07","08"]


func _ready(): 
	randomize()
	play(floor_tile[randi() % floor_tile.size()])