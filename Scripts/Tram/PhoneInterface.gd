extends Node2D

var notifications: Array = [
	$Notif,
	$Notif2,
	$Notif3
]

func move_notif_up(notif_node):
	var tween = create_tween()
	for sprite in get_children():
		tween.tween_property(sprite, "position", Vector2(0, 0), 1)


func swipe_notif_away(notif_node):
	
