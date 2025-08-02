extends Control

@onready var Left = $"../../Inside/Room/Curtains/Left"
@onready var Right = $"../../Inside/Room/Curtains/Right"
@onready var Anim: AnimationPlayer = $"../../RoomAnimation"

@export var closed_default: bool = false
signal curtains_completed

var is_swiping: bool = false
var swipe_start_pos: Vector2
var swipe_threshold: float = 5.0
var swiped = false

func start_swipe(pos: Vector2):
	if swiped:
		return
	is_swiping = true
	swipe_start_pos = pos

func end_swipe(end_pos: Vector2):
	if not is_swiping:
		return
	is_swiping = false
	var swipe_distance = end_pos - swipe_start_pos
	var swipe_length = abs(swipe_distance.x)
	if swipe_length >= swipe_threshold:
		animate_to_current_state()

func animate_to_current_state():
	print(closed_default)
	if closed_default:
		Anim.play("OpenCurtains")
		await Anim.animation_finished
		curtains_completed.emit()
	else:
		Anim.play("CloseCurtains")
		await Anim.animation_finished
		curtains_completed.emit()
	closed_default = !closed_default
	swiped = true

func _on_gui_input(event):
	handle_swipe_input(event)


func handle_swipe_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_swipe(event.position)
			else:
				end_swipe(event.position)

	elif event is InputEventMouseMotion and is_swiping:
		update_swipe(event.position)


func update_swipe(current_pos: Vector2):
	if not is_swiping:
		return
	var swipe_distance = current_pos - swipe_start_pos
	var progress = abs(swipe_distance.x) / swipe_threshold
	progress = clamp(progress, 0.0, 1.0)
