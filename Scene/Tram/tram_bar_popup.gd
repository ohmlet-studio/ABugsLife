extends Interaction
@onready var panel_container = $Popup/PanelContainer
@onready var leg = $Popup/PanelContainer/Elements/Leg
@onready var panel = $Popup/PanelContainer/Elements/Panel

var mouse_valid_once = false

func _ready():
	if panel is Control:
		panel.gui_input.connect(_on_panel_input)

func _process(delta: float) -> void:
	if not popup_ready:
		return
	
	var mouse_pos = get_global_mouse_position()
	
	leg.global_position.x = mouse_pos.x

func _on_panel_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			action_completed.emit()

func is_mouse_in_valid_area(mouse_pos: Vector2) -> bool:
	var parent_rect = panel_container.get_rect()
	var parent_global_rect = Rect2(
		panel_container.global_position, 
		parent_rect.size
	)
	
	return (mouse_pos.x >= parent_global_rect.position.x and 
			mouse_pos.x <= parent_global_rect.position.x + parent_global_rect.size.x)
