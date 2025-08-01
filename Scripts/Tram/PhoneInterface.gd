extends Control

@onready var popup = $"../../../../.."

var notifications: Array = []
var notification_height: float = 120.0
var notification_spacing: float = 25.0
var screen_width: float = 400.0
var top_position: float = 0.0

var swipe_data: Dictionary = {}  # Store swipe data for each notification
var swipe_threshold: float = 50.0
var active_tweens: Dictionary = {}  # Track tweens for each notification

func _ready():
	notifications = get_children()
	
	arrange_notifications()
	
	# Setup swipe for all notifications
	setup_swipe_for_all_notifications()

func arrange_notifications():
	for i in range(notifications.size()):
		var notif = notifications[i]
		var target_y = top_position + (i * (notification_height + notification_spacing))
		notif.position = Vector2(0, target_y)

func move_notif_up(notif_node, target_position: Vector2, duration: float = 0.3):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(notif_node, "position", target_position, duration)
	return tween

func swipe_notif_away(notif_node, direction: int = 1):
	# Kill any existing tween for this notification
	if active_tweens.has(notif_node):
		active_tweens[notif_node].kill()
		active_tweens.erase(notif_node)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	var target_x = screen_width * direction * 1.5
	var target_pos = Vector2(target_x, notif_node.position.y)
	
	var parallel_tween = create_tween()
	parallel_tween.parallel().tween_property(notif_node, "modulate:a", 0.0, 0.3)
	parallel_tween.parallel().tween_property(notif_node, "scale", Vector2(0.8, 0.8), 0.3)
	
	tween.tween_property(notif_node, "position", target_pos, 0.3)
	
	# Pass the specific notification to be removed
	tween.tween_callback(func(): remove_notification(notif_node))

func remove_notification(notif_node):
	var notif_index = notifications.find(notif_node)
	if notif_index == -1:
		return
	
	# Clean up swipe data and tweens for this notification
	swipe_data.erase(notif_node)
	if active_tweens.has(notif_node):
		active_tweens[notif_node].kill()
		active_tweens.erase(notif_node)
	
	# Disconnect signal
	if notif_node.gui_input.is_connected(_on_notification_input):
		notif_node.gui_input.disconnect(_on_notification_input)
	
	notifications.remove_at(notif_index)
	notif_node.queue_free()
	
	# Animate all notifications below the removed one moving up
	animate_notifications_up_from_index(notif_index)
		
	if notifications.size() == 0:
		popup.action_completed.emit()

func animate_notifications_up_from_index(start_index: int):
	for i in range(start_index, notifications.size()):
		var notif = notifications[i]
		var target_y = top_position + (i * (notification_height + notification_spacing))
		var target_pos = Vector2(0, target_y)
		
		await get_tree().create_timer((i - start_index) * 0.05).timeout
		move_notif_up(notif, target_pos, 0.4)

func setup_swipe_for_all_notifications():
	for notif in notifications:
		if notif.gui_input.is_connected(_on_notification_input):
			notif.gui_input.disconnect(_on_notification_input)
		
		# Create a callable that captures the notification
		var callable = func(event: InputEvent): _on_notification_input(notif, event)
		notif.gui_input.connect(callable)
		
		# Initialize swipe data for this notification
		swipe_data[notif] = {
			"is_swiping": false,
			"start_pos": Vector2.ZERO,
			"original_pos": notif.position
		}

func _on_notification_input(notif_node, event: InputEvent):
	if not swipe_data.has(notif_node):
		return
	
	var data = swipe_data[notif_node]
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				data.is_swiping = true
				data.start_pos = event.position
				data.original_pos = notif_node.position
				# Kill any existing tweens when starting to swipe
				if active_tweens.has(notif_node):
					active_tweens[notif_node].kill()
					active_tweens.erase(notif_node)
			else:
				if data.is_swiping:
					handle_swipe_end(event.position, notif_node)
				data.is_swiping = false
	
	elif event is InputEventMouseMotion and data.is_swiping:
		handle_swipe_drag(event.position, notif_node)

func handle_swipe_drag(current_pos: Vector2, notif_node):
	var data = swipe_data[notif_node]
	
	if current_pos.x < data.start_pos.x:
		return
		
	var drag_distance = current_pos.x - data.start_pos.x
	
	var max_drag = swipe_threshold * 1.5
	drag_distance = clamp(drag_distance, -max_drag, max_drag)
	
	# Get the current target Y position for this notification
	var notif_index = notifications.find(notif_node)
	var target_y = get_notification_target_y(notif_index)
	notif_node.position = Vector2(drag_distance, target_y)
	
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

func handle_swipe_end(end_pos: Vector2, notif_node):
	"""Handle the end of a swipe gesture"""
	var data = swipe_data[notif_node]
	var swipe_distance = end_pos.x - data.start_pos.x
	
	if abs(swipe_distance) >= swipe_threshold:
		# Complete the swipe
		var direction = 1 if swipe_distance > 0 else -1
		swipe_notif_away(notif_node, direction)
	else:
		# Snap back to original position
		snap_back_notification(notif_node)

func snap_back_notification(notif_node):
	# Kill any existing tween for this notification
	if active_tweens.has(notif_node):
		active_tweens[notif_node].kill()
	
	var tween = create_tween()
	active_tweens[notif_node] = tween
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	
	# Get the proper target position for this specific notification
	var notif_index = notifications.find(notif_node)
	var target_pos = Vector2(0, get_notification_target_y(notif_index))
	
	# Reset all properties to their original states
	tween.parallel().tween_property(notif_node, "position", target_pos, 0.4)
	tween.parallel().tween_property(notif_node, "scale", Vector2.ONE, 0.4)
	tween.parallel().tween_property(notif_node, "rotation", 0.0, 0.4)
	tween.parallel().tween_property(notif_node, "modulate:a", 1.0, 0.4)
	
	# Clean up the tween reference when done
	tween.finished.connect(func(): active_tweens.erase(notif_node))
