extends Control


@onready var sound_player = get_parent().get_parent().get_parent().get_parent().get_node("AudioStreamPlayer")
@onready var popup = get_parent().get_parent().get_parent().get_parent()


func fade_in_children():
	var tween = create_tween()
	for child in get_children():
		var delay: float = randf_range(.2, .7)
		tween.tween_property(child, "modulate:a", 1.0, delay)


func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0

func _process(_delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			fade_in_children()
			sound_player.play()
			await get_tree().create_timer(3).timeout
			popup.action_completed.emit()
