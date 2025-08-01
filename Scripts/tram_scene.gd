extends Node2D

@onready var interior_animation_player = $TramInterior/AnimationPlayer
@onready var interactions = $Interactions

signal scene_completed

func _ready():
	interior_animation_player.play("TramMovement")
	interactions.interaction_finished.connect(_on_interaction_finished)

func _on_interaction_finished():
	await get_tree().create_timer(0.5).timeout
	if GameStateManager.current_step_day == GameStateManager.TRAM_MORNING:
		get_tree().change_scene_to_file("res://Scene/Work/WorkScene.tscn")
	else:
		get_tree().change_scene_to_file("res://Scene/Home/HomeScene.tscn")
