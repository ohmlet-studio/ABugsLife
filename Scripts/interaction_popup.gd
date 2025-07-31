extends Node2D
class_name Interaction

@onready var animation_player = $AnimationPlayer

signal action_completed

func _init() -> void:
	action_completed.connect(make_disappear)

func _process(delta: float) -> void:
	pass
	
func reveal():
	self.show()
	animation_player.play("Appear")

func make_disappear():
	animation_player.play("Disappear")
	animation_player.animation_finished.connect(func (): self.hide())
