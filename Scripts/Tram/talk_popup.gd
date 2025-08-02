extends Interaction

@onready var bubble: Sprite2D = $Popup/PanelContainer/Elements/Bubbletext
@onready var background = $Popup/PanelContainer/Background

func _ready():
	background.gui_input.connect(_on_background_input)

func reveal():
	super.reveal()
	
	await get_tree().create_timer(0.3)
	bubble.show()
	
	action_completed.emit()

func _on_background_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot_bubble_up()

func shoot_bubble_up():
	var tween = create_tween()
	
	var start_pos = bubble.position
	var end_pos = start_pos + Vector2(0, -200)  # Adjust the distance as needed
	
	tween.tween_property(bubble, "position", end_pos, 0.5)
	tween.tween_property(bubble, "modulate:a", 0.0, 0.3)  # Fade out
	
	await tween.finished
	action_completed.emit()
