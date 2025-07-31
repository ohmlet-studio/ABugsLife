extends ParallaxBackground

@export var scroll_speed = 1

func _process(delta: float) -> void:
	self.scroll_offset.x += scroll_speed
