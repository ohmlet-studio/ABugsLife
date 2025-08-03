extends Node2D

@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	AnimPlayer.play("SceneEnter")
	await AnimPlayer.animation_finished




	AnimPlayer.play("Credits")
	await AnimPlayer.animation_finished
