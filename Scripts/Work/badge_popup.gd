extends Interaction

@onready var panel_container = $Popup/PanelContainer
@onready var leg = $Popup/PanelContainer/Elements/Leg
@onready var light_on = $"Popup/PanelContainer/Elements/LightsOn"
@onready var beep_sound = $"Popup/PanelContainer/Elements/Beep sound"
@onready var max_y = $Popup/PanelContainer/Elements/MaxYMovement.global_position.y

var is_pressed = false
var press_timer: Timer

var badge_swiped = false
var mouse_valid_once = false

func _ready():
	light_on.hide()
	press_timer = Timer.new()
	add_child(press_timer)

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if is_mouse_in_valid_area(mouse_pos):
		mouse_valid_once = true
		if mouse_pos.y < max_y:
			leg.global_position.y = mouse_pos.y
	
	if not badge_swiped and mouse_valid_once and  mouse_pos.y > max_y:
			_badge_swiped()

func is_mouse_in_valid_area(mouse_pos: Vector2) -> bool:
	var parent_rect = panel_container.get_rect()
	var parent_global_rect = Rect2(
		panel_container.global_position, 
		parent_rect.size
	)
	
	return parent_global_rect.has_point(mouse_pos)

func _badge_swiped():
	light_on.show()
	beep_sound.play()
	
	await get_tree().create_timer(0.5).timeout
	action_completed.emit()
	
	badge_swiped = true
