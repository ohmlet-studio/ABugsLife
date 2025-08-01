extends Node2D

@onready var interior_animation_player = $TramInterior/TramAnimationPlayer
@onready var interactions = $Interactions
@onready var phone_popup = $Interactions/PhonePopup
@onready var card_popup = $Interactions/CardSwipePopup
@onready var lulu = $TramInterior/Characters/Lulu
@onready var fifi = $TramInterior/Characters/Fifi

signal scene_completed


func _ready():
	phone_popup.hide()
	card_popup.hide()
	lulu.hide()
	fifi.hide()

	card_popup.action_completed.connect(_on_card_popup_finished)
	phone_popup.action_completed.connect(_on_phone_popup_finished)
	
	interior_animation_player.play("TramMovement")
	
	await get_tree().create_timer(3.0).timeout
	
	card_popup.reveal()

func _on_card_popup_finished():
	await get_tree().create_timer(0.2).timeout
	fifi.show()
	await get_tree().create_timer(0.5).timeout
	phone_popup.reveal()

func _on_phone_popup_finished():
	await get_tree().create_timer(0.5).timeout
	if GameStateManager.current_step_day == GameStateManager.TRAM_MORNING:
		get_tree().change_scene_to_file("res://Scene/Work/WorkScene.tscn")
	else:
		get_tree().change_scene_to_file("res://Scene/Home/HomeScene.tscn")
