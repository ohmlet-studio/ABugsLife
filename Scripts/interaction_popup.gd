extends Node2D
class_name Interaction

@onready var animation_player = $AnimationPlayer
signal action_completed

var popup_ready = false

func _init() -> void:
	if not action_completed.is_connected(make_disappear):
		action_completed.connect(make_disappear)

func reveal():
	self.show()
	animation_player.play("Appear")
	await animation_player.animation_finished
	popup_ready = true

func make_disappear():
	animation_player.play("Disappear")
	await animation_player.animation_finished
	queue_free()
