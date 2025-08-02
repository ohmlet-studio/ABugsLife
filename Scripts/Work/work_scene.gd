extends Node2D

@onready var keyboard_popup = $Interactions/Laptop/KeyboardPopup
@onready var screen_popup = $Interactions/Laptop/ScreenPopup
@onready var badge_popup_in = $Interactions/BadgePopupIn
@onready var badge_popup_out = $Interactions/BadgePopupOut
@onready var interactions = $Interactions
@onready var office_sounds = $"Office sound"
@onready var guirlance = $Work/Guirlande
@onready var fifi = $Work/Fifi
@onready var hat = $Work/Fifi/Hat
@onready var chenille = $Work/Chenille
@onready var worm = $Work/Worm

func _ready():
	fifi.hide()
	hat.hide()
	chenille.hide()
	worm.hide()
	badge_popup_in.hide()
	badge_popup_out.hide()
	
	office_sounds.play()
	
	keyboard_popup.keyboard_pressed.connect(_on_keyboard_pressed)
	
	keyboard_popup.action_completed.connect(_on_keyboard_action_completed, CONNECT_ONE_SHOT)
	screen_popup.action_completed.connect(_on_screen_action_completed, CONNECT_ONE_SHOT)
	badge_popup_in.action_completed.connect(_on_badge_in_action_completed, CONNECT_ONE_SHOT)
	badge_popup_out.action_completed.connect(_on_badge_out_action_completed, CONNECT_ONE_SHOT)
	
	keyboard_popup.visible = false
	screen_popup.visible = false
	
	badge_popup_in.reveal()

func _on_badge_in_action_completed():
	await get_tree().create_timer(1.0).timeout
	fifi.show()
	
	await get_tree().create_timer(0.5).timeout
	keyboard_popup.reveal()
	
	await get_tree().create_timer(.3).timeout
	screen_popup.reveal()
	await get_tree().create_timer(2.0).timeout
	keyboard_popup.reveal()
	
	await get_tree().create_timer(.3).timeout
	screen_popup.reveal()
	
	await get_tree().create_timer(1.5).timeout
	chenille.show()
	
	await get_tree().create_timer(1.5).timeout
	worm.show()


func _on_keyboard_action_completed():
	await get_tree().create_timer(1.0).timeout
	badge_popup_out.reveal()

func _on_badge_out_action_completed():
	await get_tree().create_timer(0.5).timeout
	GameStateManager.current_step_day = GameStateManager.TRAM_NIGHT
	get_tree().change_scene_to_file("res://Scene/Tram/TramScene.tscn")

func _on_keyboard_pressed():
	screen_popup.add_random_word()

func _on_screen_action_completed():
	await get_tree().create_timer(.3).timeout
	keyboard_popup.action_completed.emit()
