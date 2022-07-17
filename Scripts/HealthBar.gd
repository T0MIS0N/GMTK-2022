extends Node2D

onready var red_bar = get_node("Bar")

func _ready():
	pass # Replace with function body.
	

func _on_Frog_take_damage(health,max_health):
	var length = float(float(health)/float(max_health))
	print(length)
	red_bar.scale.x = length
