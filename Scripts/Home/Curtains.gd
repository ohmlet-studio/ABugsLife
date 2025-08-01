extends Control


@onready var Left = $Left
@onready var Right = $Right
@onready var Anim = $CurtainsAnim

@export var opened_default: bool = true

var is_swiping: bool = false
var swipe_start_pos: Vector2
var swipe_threshold: float = 10.0
var curtain_width: float = 50.0
var animation_duration: float = .8

func start_swipe(pos: Vector2):
	is_swiping = true
	swipe_start_pos = pos

func end_swipe(end_pos: Vector2):
	if not is_swiping:
		return
	is_swiping = false
	var swipe_distance = end_pos - swipe_start_pos
	var swipe_length = abs(swipe_distance.x)
	if swipe_length >= swipe_threshold:
		if swipe_distance.x > 0 and not opened_default:
			Anim.play("Open")
		elif swipe_distance.x < 0 and opened_default:
			Anim.play("Close")
		else:
			animate_to_current_state()

func animate_to_current_state():
	if opened_default:
		Anim.play("Open")
	else:
		Anim.play("Close")

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
