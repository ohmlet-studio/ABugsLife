extends Node2D

@onready var phone_popup = $PhonePopup

signal interaction_finished

func _ready():
	phone_popup.visible = false
	phone_popup.action_completed.connect(func(): interaction_finished.emit())
	
	await get_tree().create_timer(3.0).timeout
	phone_popup.reveal()
