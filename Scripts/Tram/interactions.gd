extends Node2D

@onready var interaction_popup = $PhonePopup

func _ready():
	interaction_popup.visible = false
	
	await get_tree().create_timer(3.0).timeout
	interaction_popup.reveal()
