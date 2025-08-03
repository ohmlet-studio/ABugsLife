extends Interaction
signal keyboard_pressed
@onready var sprites = [
	$Popup/PanelContainer/Background/Elements/Img0843,
	$Popup/PanelContainer/Background/Elements/Img0841,
	$Popup/PanelContainer/Background/Elements/Img0842
]
var nb_clicks = 0
var sprites_remaining: int

func _ready() -> void:
	sprites_remaining = sprites.size()
	setup_sprites()

func setup_sprites():
	for i in range(sprites.size()):
		var sprite = sprites[i]
		if sprite:
			# Create Area2D for click detection
			var area = Area2D.new()
			var collision = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			
			# Set up collision shape to match sprite size
			if sprite.texture:
				shape.size = sprite.texture.get_size()
			
			collision.shape = shape
			area.add_child(collision)
			sprite.add_child(area)
			
			# Connect the click signal with sprite index
			area.input_event.connect(_on_sprite_area_clicked.bind(i))

func _on_sprite_area_clicked(viewport: Viewport, event: InputEvent, shape_idx: int, sprite_index: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Only allow clicking the current sprite in sequence
		if sprite_index == nb_clicks and nb_clicks < sprites.size():
			hide_sprite(sprites[sprite_index])
			nb_clicks += 1

func hide_sprite(sprite: Sprite2D):
	if sprite.visible:
		sprite.visible = false
		sprites_remaining -= 1
		
		if sprites_remaining <= 0:
			action_completed.emit()
