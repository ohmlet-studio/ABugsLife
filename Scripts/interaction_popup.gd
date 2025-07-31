extends Node2D
class_name Interaction

@onready var animation_player = $AnimationPlayer

signal action_completed
	
func _process(delta: float) -> void:
	pass
	
func reveal():
	self.show()
	animation_player.play("Appear")
