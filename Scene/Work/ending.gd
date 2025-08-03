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
	await get_tree().create_timer(1).timeout
	Door_popup.get_node("Popup/PanelContainer/Elements/Door1").hide()
	Door_popup.get_node("Popup/PanelContainer/Elements/Door2").show()
	await get_tree().create_timer(1).timeout
	Door_popup.get_node("Popup/PanelContainer/Elements/Door2").hide()
	Door_popup.get_node("Popup/PanelContainer/Elements/Door3").show()
	
	Musique.play_music_end()
	get_tree().change_scene_to_file("res://Scene/FinalCutScene/FinalCutScene.tscn")
