extends Node2D

@onready var keyboard_popup = $KeyboardPopup
@onready var screen_popup = $ScreenPopup

signal interaction_finished

func _ready():
	keyboard_popup.keyboard_pressed.connect(_on_keyboard_pressed)
	keyboard_popup.action_completed.connect(_on_keyboard_action_completed)
	screen_popup.action_completed.connect(_on_screen_action_completed)
	keyboard_popup.visible = false
	screen_popup.visible = false
	
	await get_tree().create_timer(2.0).timeout
	keyboard_popup.reveal()
	
	await get_tree().create_timer(.3).timeout
	screen_popup.reveal()

func _on_keyboard_pressed():
	screen_popup.add_random_word()

func _on_screen_action_completed():
	await get_tree().create_timer(.3).timeout
	keyboard_popup.action_completed.emit()

func _on_keyboard_action_completed():
	interaction_finished.emit()
