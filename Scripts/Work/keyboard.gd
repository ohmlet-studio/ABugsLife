extends Area2D

@onready var animation_node = $"../AnimationPlayer"
var is_type_b = true

func _ready():
	input_pickable = true
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _on_mouse_entered():
	print("Mouse entered!")
	animation_node.play("Appear")

func _on_mouse_exited():
	print("Mouse exited!")
	animation_node.play_backwards("Appear")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clicked!")
		if is_type_b:
			animation_node.play("TypeB")
		else:
			animation_node.play("TypeZ")
		is_type_b = !is_type_b
