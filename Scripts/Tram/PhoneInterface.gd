extends Control

@onready var popup = $"../../../../.."

var notifications: Array = []
var notification_height: float = 40.0
var notification_spacing: float = 10.0
var screen_width: float = 400.0
var top_position: float = 0.0

var is_swiping: bool = false
var swipe_start_pos: Vector2
var swipe_threshold: float = 100.0
var current_tween: Tween  # Track current tween to avoid conflicts

func _ready():
	notifications = get_children()
	
	arrange_notifications()
	
	if notifications.size() > 0:
		setup_swipe_for_top_notification()

func arrange_notifications():
	for i in range(notifications.size()):
		var notif = notifications[i]
		var target_y = top_position + (i * (notification_height + notification_spacing))
		notif.position = Vector2(0, target_y)

func move_notif_up(notif_node: Control, target_position: Vector2, duration: float = 0.3):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(notif_node, "position", target_position, duration)
	return tween

func swipe_notif_away(notif_node: Control, direction: int = 1):
	# Kill any existing tween to avoid conflicts
	if current_tween:
		current_tween.kill()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	var target_x = screen_width * direction * 1.5
	var target_pos = Vector2(target_x, notif_node.position.y)
	
	var parallel_tween = create_tween()
	parallel_tween.parallel().tween_property(notif_node, "modulate:a", 0.0, 0.3)
	parallel_tween.parallel().tween_property(notif_node, "scale", Vector2(0.8, 0.8), 0.3)
	
	tween.tween_property(notif_node, "position", target_pos, 0.3)
	
	tween.tween_callback(remove_top_notification)

func remove_top_notification():
	if notifications.size() == 0:
		return
	
	var removed_notif = notifications[0]
	notifications.remove_at(0)
	removed_notif.queue_free()
	
	# Animate all remaining notifications moving up
	animate_all_notifications_up()
	
	# Set up swipe for the new top notification
	if notifications.size() > 0:
		setup_swipe_for_top_notification()
		
	if notifications.size() == 0:
		popup.action_completed.emit()

func animate_all_notifications_up():
	for i in range(notifications.size()):
		var notif = notifications[i]
		var target_y = top_position + (i * (notification_height + notification_spacing))
		var target_pos = Vector2(0, target_y)
		
		await get_tree().create_timer(i * 0.05).timeout
		move_notif_up(notif, target_pos, 0.4)

func setup_swipe_for_top_notification():
	if notifications.size() == 0:
		return
	
	var top_notif = notifications[0]
	
	if top_notif.gui_input.is_connected(_on_notification_input):
		top_notif.gui_input.disconnect(_on_notification_input)
	
	top_notif.gui_input.connect(_on_notification_input)

func _on_notification_input(event: InputEvent):
	if notifications.size() == 0:
		return
	
	var top_notif = notifications[0]
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_swiping = true
				swipe_start_pos = event.position
				# Kill any existing tweens when starting to swipe
				if current_tween:
					current_tween.kill()
			else:
				if is_swiping:
					handle_swipe_end(event.position, top_notif)
				is_swiping = false
	
	elif event is InputEventMouseMotion and is_swiping:
		handle_swipe_drag(event.position, top_notif)

func handle_swipe_drag(current_pos: Vector2, notif_node: Control):
	if current_pos.x < swipe_start_pos.x:
		return
		
	var drag_distance = current_pos.x - swipe_start_pos.x
	
	var max_drag = swipe_threshold * 1.5
	drag_distance = clamp(drag_distance, -max_drag, max_drag)
	
	# Store the original Y position to maintain it
	var original_y = get_notification_target_y(0)  # Top notification's target Y
	notif_node.position = Vector2(drag_distance, original_y)
	
	# Add some visual feedback - scale and rotate slightly based on drag
	var drag_ratio = abs(drag_distance) / swipe_threshold
	var scale_factor = 1.0 - (drag_ratio * 0.1)  # Slight scale down
	var rotation_angle = drag_distance * 0.0005  # Slight rotation
	
	notif_node.scale = Vector2(scale_factor, scale_factor)
	notif_node.rotation = rotation_angle
	
	var alpha = 1.0 - (drag_ratio * 0.3)
	notif_node.modulate.a = clamp(alpha, 0.4, 1.0)

func get_notification_target_y(index: int) -> float:
	"""Helper function to get the target Y position for a notification at given index"""
	return top_position + (index * (notification_height + notification_spacing))

func handle_swipe_end(end_pos: Vector2, notif_node: Control):
	"""Handle the end of a swipe gesture"""
	var swipe_distance = end_pos.x - swipe_start_pos.x
	
	if abs(swipe_distance) >= swipe_threshold:
		# Complete the swipe
		var direction = 1 if swipe_distance > 0 else -1
		swipe_notif_away(notif_node, direction)
	else:
		# Snap back to original position
		snap_back_notification(notif_node)

func snap_back_notification(notif_node: Control):
	# Kill any existing tween
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.set_trans(Tween.TRANS_SPRING)
	
	# Get the proper target position (this is key!)
	var target_pos = Vector2(0, get_notification_target_y(0))
	
	# Reset all properties to their original states
	current_tween.parallel().tween_property(notif_node, "position", target_pos, 0.4)
	current_tween.parallel().tween_property(notif_node, "scale", Vector2.ONE, 0.4)
	current_tween.parallel().tween_property(notif_node, "rotation", 0.0, 0.4)
	current_tween.parallel().tween_property(notif_node, "modulate:a", 1.0, 0.4)
