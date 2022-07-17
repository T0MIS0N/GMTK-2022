extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	set_cell(10,1,1)
	print(get_used_cells())
