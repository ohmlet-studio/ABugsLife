extends Control


var COUNT: int

@onready var root = get_parent().get_parent().get_parent().get_parent()
@onready var KeyboardAnimation = root.get_node("KeyboardAnimation")
@onready var ScreenText = get_parent().get_node("ScreenText")
@onready var Sound1 = root.get_node("Sound1")
@onready var Sound2 = root.get_node("Sound2")

func _ready() -> void:
	pass

func b_keystroke():
	KeyboardAnimation.play("bPressed")
	ScreenText.text += "B"
	Sound1.play()

func z_keystroke():
	KeyboardAnimation.play("zPressed")
	ScreenText.text += "Z"
	Sound2.play()

func process_input():
	if COUNT % 2 == 0:
		b_keystroke()
	else:
		z_keystroke()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if COUNT < 12:
				process_input()
				COUNT += 1
				return
			root.action_completed.emit()
