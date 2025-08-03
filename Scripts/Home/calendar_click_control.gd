extends Control

@onready var sound_player = $"../AudioStreamPlayer"
@onready var popup = $"../../../.."

func _ready() -> void:
	popup.visibility_changed.connect(refresh_calendar)

func refresh_calendar() -> void:
	for child in get_children():
		var child_day = child.name.replace("Jour", "").to_int()
		print(child.name)
		for sub_child in child.get_children():
			if child_day < GameStateManager.current_day+1:
				sub_child.modulate.a = 1
			else:
				sub_child.modulate.a = 0


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			sound_player.play()
			await fade_in_children()
			popup.action_completed.emit()

func fade_in_children():
	var tween = create_tween()
	var formatted_day = "Jour%o" % (GameStateManager.current_day + 1)
	var day = get_node(formatted_day)
	for child in day.get_children():
		var delay: float = randf_range(.2, .7)
		tween.tween_property(child, "modulate:a", 1.0, delay)
		await popup.get_tree().create_timer(3).timeout
