extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_GridObjects_set_button(enabled):
	disabled = enabled
