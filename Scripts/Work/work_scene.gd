extends Node2D

@onready var interactions = $Interactions
@onready var keyboard_popup = $Interactions/KeyboardPopup
@onready var office_sounds = $"Office sound"

func _ready():
	office_sounds.play()
	interactions.interaction_finished.connect(_on_interaction_finished)

func _on_interaction_finished():
	await get_tree().create_timer(0.5).timeout
	GameStateManager.current_step_day = GameStateManager.TRAM_NIGHT
	get_tree().change_scene_to_file("res://Scene/Tram/TramScene.tscn")
