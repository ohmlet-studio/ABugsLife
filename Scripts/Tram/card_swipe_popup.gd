extends Interaction

@onready var elements = $Popup/PanelContainer/Elements
@onready var leg = $Popup/PanelContainer/Elements/Leg
@onready var animation_node = $Popup/PanelContainer/Elements/Leg/SwipeAnimationPlayer
@onready var light_on = $Popup/PanelContainer/Elements/LightsOn
@onready var beep_sound = $"Popup/PanelContainer/Elements/Beep sound"

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
		leg.global_position = get_global_mouse_position()

func _input(event):
	if not popup_ready:
		return
		
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
		leg.hide()
		beep_sound.play()
		
		await get_tree().create_timer(0.5).timeout
		emit_signal("action_completed")
