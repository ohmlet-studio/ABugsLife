extends Interaction

@onready var elements = $Popup/PanelContainer/Elements

func _ready():
	elements.action_completed.connect(func(): action_completed.emit())
