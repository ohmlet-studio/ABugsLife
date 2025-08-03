extends ParallaxBackground

@export var scroll_speed: float

func _process(_delta: float) -> void:
	self.scroll_offset.x += scroll_speed
	self.scroll_offset.y += scroll_speed* .2
