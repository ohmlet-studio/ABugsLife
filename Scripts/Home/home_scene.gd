extends Node2D

@onready var AnimPlayer: AnimationPlayer = $RoomAnimation
@onready var CalendrierPopup = $Interactions/CalendrierPopup
@onready var CurtainPopup = $Interactions/CurtainPopup
@onready var CalendarArr: Node2D = $Inside/Room/Calendar
@onready var BadgePopup: Interaction = $Interactions/FifiBday
@onready var VaissellePopup: Interaction = $Interactions/VaisellePopup


func _ready():
	GameStateManager.current_step_day = GameStateManager.ROOM_NIGHT
	set_calendar_visibility()
	CalendrierPopup.hide()
	CurtainPopup.hide()
	BadgePopup.hide()
	VaissellePopup.hide()
	BadgePopup.action_completed.connect(tram_change)
	VaissellePopup.action_completed.connect(tram_change)
	CalendrierPopup.action_completed.connect(_on_calendar_popup_finished)
	await night()


func set_calendar_visibility():
	for child in CalendarArr.get_children():
		child.hide()
	var format = "Calendrier%o"
	var calendar_node = CalendarArr.get_node(format % (GameStateManager.current_day+1))
	if calendar_node:
		calendar_node.show()


func _on_calendar_popup_finished():
	if GameStateManager.current_step_day == GameStateManager.ROOM_MORNING:
		match GameStateManager.current_day:
			2: VaissellePopup.reveal()
			3: BadgePopup.reveal()
			_: tram_change()
func tram_change():
	await get_tree().create_timer(1.0).timeout
	GameStateManager.current_step_day = GameStateManager.TRAM_MORNING
	get_tree().change_scene_to_file("res://Scene/Tram/tramScene.tscn")


func morning():
	AnimPlayer.play("NightToDay")
	await AnimPlayer.animation_finished
	AnimPlayer.play("AuReveil")
	await AnimPlayer.animation_finished
	if GameStateManager.current_day > 0:
		AnimPlayer.speed_scale = 1.0
	open_curtain_popup()


func night():
	await handle_curtain_popup()


func handle_curtain_popup():
	await open_curtain_popup()


func open_curtain_popup():
	CurtainPopup.swiped = false
	CurtainPopup.show()
	AnimPlayer.play("AppearCurtainPopup")
	await AnimPlayer.animation_finished


func _on_curtain_popup_curtains_completed() -> void:
	AnimPlayer.play("DisappearCurtainPopup")
	print(GameStateManager.current_step_day)
	print(GameStateManager.ROOM_MORNING)
	if GameStateManager.current_step_day == GameStateManager.ROOM_MORNING:
		Musique.play_music_level()
	await AnimPlayer.animation_finished
	if GameStateManager.current_step_day == GameStateManager.ROOM_NIGHT:
		if GameStateManager.current_day > 0:
			AnimPlayer.speed_scale = 3.0
		AnimPlayer.play("RoomDayToNight")
		await AnimPlayer.animation_finished
		CurtainPopup.hide()
		AnimPlayer.play("AuDodo")
		await AnimPlayer.animation_finished
		GameStateManager.current_day += 1
		GameStateManager.current_step_day = GameStateManager.ROOM_MORNING
		await morning()

	elif GameStateManager.current_step_day == GameStateManager.ROOM_MORNING:
		CurtainPopup.hide()
		AnimPlayer.play("FenetreToCalendar")
		await AnimPlayer.animation_finished
		await get_tree().create_timer(1).timeout
		CalendrierPopup.reveal()
