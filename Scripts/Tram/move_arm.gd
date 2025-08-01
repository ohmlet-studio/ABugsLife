extends Sprite2D
signal action_completed

@onready var animation_node = $SwipeAnimationPlayer
@onready var light_on = $"../LightsOn"

var is_pressed = false
var press_timer: Timer

func _ready():
	light_on.hide()
	
	press_timer = Timer.new()
	press_timer.wait_time = 0.5
	press_timer.one_shot = true
	press_timer.timeout.connect(_on_press_timer_timeout)
	add_child(press_timer)

func _process(delta: float) -> void:
	if not is_pressed:
		global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_pressed:
				is_pressed = true
				animation_node.play("PressCard")
				press_timer.start()
			elif not event.pressed and is_pressed:
				is_pressed = false
				animation_node.play_backwards("PressCard")
				press_timer.stop()

func _on_press_timer_timeout():
	if is_pressed:
		light_on.show()
		hide()
		# TODO beep sound
		
		await get_tree().create_timer(0.5).timeout
		emit_signal("action_completed")
