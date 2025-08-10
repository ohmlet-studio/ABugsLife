extends Interaction
@onready var panel_container = $Popup/PanelContainer
@onready var leg = $Popup/PanelContainer/Elements/Legs
@onready var max_y = $Popup/PanelContainer/Elements/MaxYMovement.global_position.y
@onready var hat: Sprite2D = $Popup/PanelContainer/Elements/Hat
@export var going_in = false

var has_hat_been_inserted = false
var mouse_valid_once = false
var is_pressed = false
var is_holding_hat = false


func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if not is_holding_hat and is_mouse_over_hat(mouse_pos):
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_holding_hat = true
	
	# Handle drag end
	if is_holding_hat and (Input.is_action_just_released("ui_accept") or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		is_holding_hat = false
	
	if is_mouse_in_valid_area(mouse_pos) and mouse_pos.y < max_y:
		leg.global_position.y = mouse_pos.y
	
	if is_holding_hat:
		mouse_valid_once = true
	
		if hat.global_position.y > max_y:
			hat_inserted()
		else:
			hat.global_position.y = mouse_pos.y

func is_mouse_in_valid_area(mouse_pos: Vector2) -> bool:
	var parent_rect = panel_container.get_rect()
	var parent_global_rect = Rect2(
		panel_container.global_position, 
		parent_rect.size
	)
	
	return (mouse_pos.x >= parent_global_rect.position.x and 
			mouse_pos.x <= parent_global_rect.position.x + parent_global_rect.size.x)

func is_mouse_over_hat(mouse_pos: Vector2) -> bool:
	var hat_rect = Rect2(hat.global_position - hat.get_rect().size / 2, hat.get_rect().size)
	return hat_rect.has_point(mouse_pos)

func hat_inserted():
	if going_in:
		pass
 		#light_in.show()
	else:
		pass
		#light_out.show()
	#beep_sound.play()
	
	is_holding_hat = false
	hat.modulate.a = 1.0
	
	await get_tree().create_timer(0.5).timeout
	action_completed.emit()
	
	has_hat_been_inserted = true
