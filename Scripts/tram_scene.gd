extends Node2D

@onready var interior_animation_player = $TramInterior/AnimationPlayer

func _ready():
	interior_animation_player.play("TramMovement")
