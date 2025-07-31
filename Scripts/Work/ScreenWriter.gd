extends Interaction

@onready var label = $Popup/PanelContainer/Background4/Elements/Label

var words_needed = 15
var word_count = 0

var words = ["BZZ ", "BZZBZZ ", "BZ ", "BZZZ ", "BZZZ ", "BZZBZ "]
var cursor_char = "_"

var current_text = ""

func add_random_word():
	current_text += words.pick_random()
	label.text = current_text + cursor_char
	word_count += 1
	
	if word_count >= words_needed:
		self.action_completed.emit()
