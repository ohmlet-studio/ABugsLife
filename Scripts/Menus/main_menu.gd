extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	Musique.play_music_level()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Tram/tramScene.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Menus/Credits.tscn")
