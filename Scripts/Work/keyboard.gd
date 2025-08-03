extends Area2D

@onready var animation_node = $"../AnimationPlayer"
@onready var popup_parent = $"../../../../.."
@onready var Sound1 = $Sound1
@onready var Sound2 = $Sound2

var is_type_b = true

func _on_mouse_entered():
	animation_node.play("Appear")

func _on_mouse_exited():
	animation_node.play_backwards("Appear")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_type_b:
			animation_node.play("TypeB")
			Sound1.play()
		else:
			animation_node.play("TypeZ")
			Sound2.play()
		is_type_b = !is_type_b
		
		popup_parent.keyboard_pressed.emit()
		
