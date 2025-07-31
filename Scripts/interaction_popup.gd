extends Node2D

@onready var animation_player = $AnimationPlayer
signal action_completed

func _init() -> void:
	self.hide()
	
func _process(delta: float) -> void:
	pass
	
func reveal():
	self.show()
	animation_player.play("Appear")
