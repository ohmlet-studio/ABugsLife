extends "res://Scripts/Tram/move_arm.gd"

@export var speed_treshold_squared = 10
@export var grace_period_frames = 30  # Number of frames to wait before stopping
@onready var foam_particles = $CPUParticles2D
@onready var active_area: PanelContainer = $".."

var is_washing_dishes = false
var position_last_frame: Vector2
var frames_below_threshold = 0

func _ready() -> void:
	foam_particles.emitting = false

func _process(delta: float) -> void:
	super._process(delta)
	if position_last_frame and active_area.get_rect().has_point(position):
		var frame_speed = global_position.distance_to(position_last_frame)
		
		# Check if movement is above threshold
		if frame_speed > speed_treshold_squared:
			is_washing_dishes = true
			frames_below_threshold = 0  # Reset counter when moving fast
		else:
			# Movement is below threshold, increment counter
			frames_below_threshold += 1
			
			# Only stop washing if we've been below threshold for grace period
			if frames_below_threshold >= grace_period_frames:
				is_washing_dishes = false
	
		foam_particles.emitting = is_washing_dishes
	
	position_last_frame = global_position
