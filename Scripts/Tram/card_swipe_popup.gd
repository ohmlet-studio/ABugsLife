extends Interaction

@onready var leg = $Popup/PanelContainer/Elements/Leg

func _ready():
	leg.action_completed.connect(func(): action_completed.emit())
