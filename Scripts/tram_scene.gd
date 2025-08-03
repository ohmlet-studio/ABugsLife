extends Node2D

@onready var interior_animation_player = $TramInterior/TramAnimationPlayer
@onready var interactions = $Interactions
@onready var phone_popup = $Interactions/PhonePopup
@onready var card_popup = $Interactions/CardSwipePopup
@onready var talk_popup = $Interactions/TalkPopup
@onready var lulu = $TramInterior/Characters/Lulu
@onready var fifi = $TramInterior/Characters/Fifi
@onready var parallax = $TramExterior/ParallaxBackground
@onready var bubble_lulu = $TramInterior/Characters/Bubbles/BubbleLulu
@onready var bubble_fifi = $TramInterior/Characters/Bubbles/BubbleFifi
@onready var sound_ambiance = $"metro sound"
@onready var notif = $notif

signal scene_completed
var is_tram_moving = false
var target_scroll_speed = 0.0
var current_scroll_speed = 0.0
var scroll_tween: Tween
var acceleration_time = 2.0

var dialog_option = {
	0: "",
	1: "...",
	2: "..bz.",
	3: "bz",
	4: "Bz!"
}

var fifi_sprite

func _ready():
	phone_popup.hide()
	card_popup.hide()
	talk_popup.hide()
	bubble_lulu.hide()
	bubble_fifi.hide()
	
	lulu.hide()
	interactions.show()
	
	talk_popup.action_completed.connect(_on_talk_finished)
	card_popup.action_completed.connect(_on_card_popup_finished)
	phone_popup.action_completed.connect(_on_phone_popup_finished)
	
	await get_tree().create_timer(1).timeout
	
	card_popup.reveal()
	
	bubble_fifi.get_node("Bubble/Label").text = dialog_option[GameStateManager.current_day]
	
	if GameStateManager.current_day < 3:
		fifi_sprite = fifi.get_node("fifi_idle") 
	else:
		fifi_sprite = fifi.get_node("fifi_idle_bday")

func _process(delta: float) -> void:
	var base_speed = 1 if is_tram_moving else 0
	
	if GameStateManager.current_step_day == GameStateManager.TRAM_NIGHT:
		base_speed *= -1
		
	if target_scroll_speed != base_speed:
		target_scroll_speed = base_speed
		interpolate_scroll_speed()
	
	parallax.scroll_speed = current_scroll_speed

func interpolate_scroll_speed():
	if scroll_tween:
		scroll_tween.kill()
	
	scroll_tween = create_tween()
	scroll_tween.tween_property(self, "current_scroll_speed", target_scroll_speed, acceleration_time)
	
func _on_card_popup_finished():
	await get_tree().create_timer(0.5).timeout
	fifi_sprite.show()
	is_tram_moving = true
	sound_ambiance.play()
	interior_animation_player.play("TramMovement")
	await get_tree().create_timer(2).timeout

	if GameStateManager.current_day <= 1 or GameStateManager.current_day == 3 or GameStateManager.current_step_day != GameStateManager.TRAM_MORNING:
		phone_popup.reveal()
		notif.play()
	else:
		change_scene()
		await get_tree().create_timer(1).timeout # pour rajouter du temps avant arret

func _on_phone_popup_finished():
	if GameStateManager.current_day < 1:
		return await change_scene()
	
	if GameStateManager.current_step_day == GameStateManager.TRAM_MORNING:
		_play_talking_anim()
	else:
		change_scene()
	
func _play_talking_anim():
	await get_tree().create_timer(0.5).timeout
	
	lulu.show()
	lulu.get_node("lulu_idle").show()
	
	await get_tree().create_timer(1).timeout
	
	lulu.get_node("lulu_idle").hide()
	lulu.get_node("lulu_talking").show()
	
	await get_tree().create_timer(0.7).timeout
	
	bubble_lulu.show()
	bubble_lulu.get_node("Bubble/AnimationPlayer").play("Appear")
	
	await get_tree().create_timer(1).timeout
	
	talk_popup.reveal()
	
func _on_talk_finished():
	bubble_fifi.show()
	var fifi_bubble_anim: AnimationPlayer = bubble_fifi.get_node("Bubble/AnimationPlayer")
	fifi_bubble_anim.play("Appear")
	
	fifi_sprite.hide()
	
	match GameStateManager.current_day:
		1: fifi.get_node("fifi_talk").show()
		2: fifi.get_node("fifi_talk_smile").show()
		3: fifi.get_node("fifi_talk_blush").show()
	
	lulu.get_node("lulu_idle").show()
	lulu.get_node("lulu_talking").hide()
	
	await get_tree().create_timer(0.5).timeout

	change_scene()
	
func change_scene():

	is_tram_moving = false
	interior_animation_player.pause()

	await get_tree().create_timer(acceleration_time).timeout
	
	sound_ambiance.stop()
	
	if GameStateManager.current_step_day == GameStateManager.TRAM_MORNING:
		get_tree().change_scene_to_file("res://Scene/Work/WorkScene.tscn")
		GameStateManager.current_step_day == GameStateManager.WORK
	else:
		get_tree().change_scene_to_file("res://Scene/Home/HomeScene.tscn")
		GameStateManager.current_step_day == GameStateManager.ROOM_NIGHT
