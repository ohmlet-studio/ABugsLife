extends Interaction

@onready var bubble: Sprite2D = $Popup/PanelContainer/Elements/Bubbletext
@onready var background = $Popup/PanelContainer/Background
@onready var label = $Popup/PanelContainer/Elements/Bubbletext/Label

var dialog_option = {
	0: "",
	1: "...",
	2: "..bz.",
	3: "bz",
	4: "Bz!"
}

func _ready():
	background.gui_input.connect(_on_background_input)
	label.text = dialog_option[GameStateManager.current_day]

func reveal():
	super.reveal()
	
	await get_tree().create_timer(0.3)
	bubble.show()

func _on_background_input(event: InputEvent):
	if not popup_ready:
		return
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot_bubble_up()

func shoot_bubble_up():
	print("SHOOTING UP BUBBLE")
	var tween = create_tween()
	
	var start_pos = bubble.position
	var end_pos = start_pos + Vector2(0, -200)  # Adjust the distance as needed
	
	tween.tween_property(bubble, "position", end_pos, 0.5)
	tween.tween_property(bubble, "modulate:a", 0.0, 0.3)  # Fade out
	
	await tween.finished
	action_completed.emit()
