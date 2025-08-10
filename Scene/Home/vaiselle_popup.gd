extends Interaction
signal keyboard_pressed

@export var cleaning_time_per_sprite = 1.0  # Time in seconds to clean each sprite
@onready var sprites = [
	$Popup/PanelContainer/Background/Elements/Img0843,
	$Popup/PanelContainer/Background/Elements/Img0841,
	$Popup/PanelContainer/Background/Elements/Img0842
]
@onready var leg = $Popup/PanelContainer/Background/Elements/Leg

var is_cleaning = false
var current_sprite_index = 0
var current_tween: Tween
var previous_washing_state = false

func _ready() -> void:
	popup_ready = true
	previous_washing_state = leg.is_washing_dishes

func _process(_delta):
	if not popup_ready:
		return
	
	# Check if washing state changed
	if leg.is_washing_dishes != previous_washing_state:
		if leg.is_washing_dishes and not is_cleaning:
			start_cleaning()
		elif not leg.is_washing_dishes:
			stop_cleaning_and_reset()
		
		previous_washing_state = leg.is_washing_dishes

func start_cleaning():
	if is_cleaning:
		return
	
	is_cleaning = true
	current_sprite_index = 0
	clean_next_sprite()

func clean_next_sprite():
	if not leg.is_washing_dishes:
		return
	
	if current_sprite_index >= sprites.size():
		# All sprites cleaned
		is_cleaning = false
		action_completed.emit()
		print("All sprites cleaned!")
		return
	
	var current_sprite = sprites[current_sprite_index]
	if not is_instance_valid(current_sprite):
		current_sprite_index += 1
		clean_next_sprite()
		return
	
	print("Cleaning sprite ", current_sprite_index)
	
	# Create tween to fade out the sprite
	current_tween = create_tween()
	current_tween.tween_property(current_sprite, "modulate:a", 0.0, cleaning_time_per_sprite)
	
	# When tween finishes, remove sprite and move to next
	current_tween.tween_callback(func():
		if is_instance_valid(current_sprite):
			current_sprite.queue_free()
		current_sprite_index += 1
		clean_next_sprite()
	)

func stop_cleaning_and_reset():
	if current_tween and current_tween.is_valid():
		current_tween.pause()
	is_cleaning = false
	print("Cleaning stopped!")
