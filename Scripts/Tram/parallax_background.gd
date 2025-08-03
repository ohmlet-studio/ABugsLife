extends ParallaxBackground

@export var scroll_speed = 1

@onready var night_elements = [
	$ParallaxLayer3/NightSky,
	$ParallaxLayer2/NightClouds,
	$ParallaxLayer/NightBuildingsBack,
	$ParallaxLayer4/NightBuildingsFront,
	$"../../TramInterior/Lights/NightLights",
	$"../../TramInterior/NightShadowBox",
	$"../../TramInterior/Characters/Passenger/passenger2"
]

func _ready() -> void:
	if GameStateManager.current_step_day == GameStateManager.TRAM_NIGHT:
		for node in night_elements:
			node.show()
	else:
		for node in night_elements:
			node.hide()

func _process(_delta: float) -> void:
	self.scroll_offset.x += scroll_speed
