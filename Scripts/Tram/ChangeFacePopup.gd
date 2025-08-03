extends Node2D

func _ready() -> void:
	for child in get_children():
		child.hide()
	
	match GameStateManager.current_day:
		0: $Idle.show()
		1: $Idle.show()
		2: $Idle3.show()
		3: $Idle4.show()
