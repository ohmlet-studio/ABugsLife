extends Control

@onready var animation_player = $AnimationPlayer

func _on_start_pressed() -> void:
	animation_player.play("ZoomInMenu")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scene/tramScene.tscn")


func _on_credits_pressed() -> void:
	pass # Replace with function body.
