extends Node2D

@onready var HUH_popup = $HuhPopup
@onready var Taptaptap_popup = $TaptaptapPopup
@onready var Door_popup = $DoorPopup

func _ready():
	HUH_popup.hide()
	Taptaptap_popup.hide()
	Door_popup.hide()

func end():
	await get_tree().create_timer(2).timeout
	HUH_popup.show()
	HUH_popup.get_node("AnimationPlayer").play("Appear")
	await get_tree().create_timer(2).timeout
	Taptaptap_popup.show()
	Taptaptap_popup.get_node("AnimationPlayer").play("Appear")
	await get_tree().create_timer(2).timeout
	Door_popup.show()
	Door_popup.get_node("AnimationPlayer").play("Appear")
