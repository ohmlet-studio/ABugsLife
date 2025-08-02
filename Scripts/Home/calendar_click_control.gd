extends Control


@onready var sound_player = $"../AudioStreamPlayer"
@onready var popup = $"../../../.."

func fade_in_children():
	var tween = create_tween()
	var formatted_day = "Jour%o" % (GameStateManager.current_day + 1)
	var day = get_node(formatted_day)
	for child in day.get_children():
		var delay: float = randf_range(.2, .7)
		tween.tween_property(child, "modulate:a", 1.0, delay)

func _ready() -> void:
	GameStateManager.current_day += 1
	for i in GameStateManager.current_day:
		var formatted_day = "Jour%o" % (i + 1)


	for child in get_children():
		for sub_child in child.get_children():
			sub_child.modulate.a = 0



func _process(_delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			fade_in_children()
			sound_player.play()
			await get_tree().create_timer(3).timeout
			popup.action_completed.emit()
