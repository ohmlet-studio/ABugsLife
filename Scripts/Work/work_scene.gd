extends Node2D

@onready var keyboard_popup = $Interactions/Laptop/KeyboardPopup
@onready var screen_popup = $Interactions/Laptop/ScreenPopup
@onready var badge_popup_in = $Interactions/BadgePopupIn
@onready var badge_popup_out = $Interactions/BadgePopupOut
@onready var interactions = $Interactions
@onready var office_sounds = $"OfficeSound"
@onready var guirlance = $Work/Guirlande
@onready var fifi = $Work/Fifi
@onready var hat = $Work/Fifi/Hat
@onready var guirlande = $Work/Guirlande
@onready var guirlande_off = $Work/GuirlandeOff
@onready var chenille = $Work/Chenille
@onready var worm = $Work/Worm
@onready var darken_rect = $DarkenRect
@onready var ending = $Ending

var word_count = 0

func _ready():
	fifi.hide()
	hat.hide()
	guirlande.hide()
	guirlande_off.hide()
	
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
	
	if GameStateManager.current_day == 3:
		hat.show()
		guirlande.show()

func _on_badge_in_action_completed():
	await get_tree().create_timer(0.5).timeout
	darken_rect.modulate.a = 0 # TODO modulate from alpha 0 to alpha 1 in one second
	
	await get_tree().create_timer(0.5).timeout
	fifi.show()
	
	await get_tree().create_timer(1.0).timeout
	keyboard_popup.reveal()
	
	await get_tree().create_timer(.3).timeout
	screen_popup.reveal()
	
	if GameStateManager.current_day < 3:
		await get_tree().create_timer(1.5).timeout
	chenille.show()
	
	if GameStateManager.current_day < 3:
		await get_tree().create_timer(1.5).timeout
	worm.show()

func _on_keyboard_action_completed():
	await get_tree().create_timer(1.0).timeout
	badge_popup_out.reveal()

func _on_badge_out_action_completed():
	await get_tree().create_timer(0.5).timeout
	GameStateManager.current_step_day = GameStateManager.TRAM_NIGHT
	get_tree().change_scene_to_file("res://Scene/Tram/tramScene.tscn")

func _on_keyboard_pressed():
	if is_instance_valid(screen_popup):
		word_count = screen_popup.add_random_word()
		if GameStateManager.current_day == 3 and word_count == 7:
			Musique.stop_music()
		#if word_count == 7:
			keyboard_popup.hide()
			screen_popup.hide()
			darken_rect.modulate.a = 1
			guirlance.hide()
			guirlande_off.show()
			ending.end()

func _on_screen_action_completed():
	await get_tree().create_timer(.3).timeout
	keyboard_popup.action_completed.emit()
