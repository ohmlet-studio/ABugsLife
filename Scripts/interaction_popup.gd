extends Node2D
class_name Interaction

@onready var animation_player = $AnimationPlayer
signal action_completed

func _init() -> void:
	if not action_completed.is_connected(make_disappear):
		action_completed.connect(make_disappear)

func _process(_delta: float) -> void:
	pass
	
func reveal():
	self.show()
	animation_player.play("Appear")

func make_disappear():
	animation_player.play("Disappear")
	await animation_player.animation_finished
	queue_free()
