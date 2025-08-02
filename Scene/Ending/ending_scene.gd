extends Node2D

@onready var HUHPopup = $Interactions/HUHPopup
@onready var TAPTAPTAPPopup = $Interactions/StairsPopup
@onready var DoorPopup = $Interactions/DoorPopup
@onready var office_sounds = $"Office sound"


func _ready():
	await get_tree().create_timer(5.0).timeout
	HUHPopup.visible = true
	await get_tree().create_timer(2.0).timeout
	DoorPopup.visible = true
	await get_tree().create_timer(2.0).timeout
	TAPTAPTAPPopup.visible = true
	
	
