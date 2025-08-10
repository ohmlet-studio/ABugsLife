extends Interaction
@onready var panel_container = $Popup/PanelContainer
@onready var leg = $Popup/PanelContainer/Elements/Leg
@onready var light_in = $"Popup/PanelContainer/Elements/LightsIn"
@onready var light_out = $"Popup/PanelContainer/Elements/LightsOut"
@onready var beep_sound = $"Popup/PanelContainer/Elements/Beep sound"
@onready var max_y = $Popup/PanelContainer/Elements/MaxYMovement.global_position.y
@onready var badge: Sprite2D = $Popup/PanelContainer/Elements/Card
@export var going_in = false
var has_badge_been_inserted = false
var mouse_valid_once = false
var is_pressed = false
var is_holding_badge = false
var playing_anim = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready():
	light_in.hide()
	light_out.hide()
	

func _process(delta: float) -> void:
	if playing_anim:
		return
		
	if not popup_ready:
		return
	
	var mouse_pos = get_global_mouse_position()
	
	# Handle drag start
	if not is_holding_badge and is_mouse_over_badge(mouse_pos):
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_holding_badge = true
			# Calculate offset from mouse position to badge center
			drag_offset = badge.global_position - mouse_pos
	
	# Handle drag end
	if is_holding_badge and (Input.is_action_just_released("ui_accept") or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		is_holding_badge = false
	
	if is_mouse_in_valid_area(mouse_pos) and mouse_pos.y < max_y:
		leg.global_position.y = mouse_pos.y
	
	if is_holding_badge:
		badge.global_position.y = mouse_pos.y + drag_offset.y
		mouse_valid_once = true
	
		# Check if badge has moved past max_y threshold
		if badge.global_position.y > max_y:
			playing_anim = true
			badge_inserted()

func is_mouse_in_valid_area(mouse_pos: Vector2) -> bool:
	var parent_rect = panel_container.get_rect()
	var parent_global_rect = Rect2(
		panel_container.global_position, 
		parent_rect.size
	)
	
	return (mouse_pos.x >= parent_global_rect.position.x and 
			mouse_pos.x <= parent_global_rect.position.x + parent_global_rect.size.x)

func is_mouse_over_badge(mouse_pos: Vector2) -> bool:
	var badge_rect = Rect2(badge.global_position - badge.get_rect().size / 2, badge.get_rect().size)
	return badge_rect.has_point(mouse_pos)

func badge_inserted():
	if going_in:
		light_in.show()
	else:
		light_out.show()
	beep_sound.play()
	
	is_holding_badge = false
	badge.modulate.a = 1.0
	
	await get_tree().create_timer(0.5).timeout
	action_completed.emit()
	
	has_badge_been_inserted = true
