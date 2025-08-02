extends Node2D

@onready var AnimPlayer: AnimationPlayer = $RoomAnimation
@onready var CalendrierPopup = $Interactions/CalendrierPopup
@onready var CurtainPopup = $Interactions/CurtainPopup
@onready var CalendarArr: Node2D = $Inside/Room/Calendar


func _ready():
	GameStateManager.current_step_day = GameStateManager.ROOM_NIGHT #debug pour lancer la scene seule

	set_calendar_visibility()
	CalendrierPopup.hide()
	CurtainPopup.hide()
	await get_tree().create_timer(1).timeout
	await night()


func set_calendar_visibility():
	print(GameStateManager.current_day)
	for child in CalendarArr.get_children():
		child.hide()
	var format = "Calendrier%o"
	CalendarArr.get_node(format % (GameStateManager.current_day+1)).show()


func _on_calendar_popup_finished():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scene/Tram/tramScene.tscn")


func morning():
	AnimPlayer.play("NightToDay")
	await AnimPlayer.animation_finished
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
	await AnimPlayer.animation_finished
	await get_tree().create_timer(2).timeout

	if GameStateManager.current_step_day == GameStateManager.ROOM_NIGHT:
		AnimPlayer.play("RoomDayToNight")
		await AnimPlayer.animation_finished
		CurtainPopup.hide()
		await get_tree().create_timer(2).timeout
		GameStateManager.current_day += 1
		GameStateManager.current_step_day = GameStateManager.ROOM_MORNING
		await morning()

	elif GameStateManager.current_step_day == GameStateManager.ROOM_MORNING:
		CurtainPopup.hide()
		await get_tree().create_timer(1).timeout
		CalendrierPopup.action_completed.connect(_on_calendar_popup_finished)
		CalendrierPopup.reveal()

	else:
		print(GameStateManager.current_step_day)
