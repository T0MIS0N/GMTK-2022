extends TileMap

signal move_tile_clicked(position)
signal enemy_moved(position)
signal player_get_hit(damage)
signal enemy_get_hit(damage)
signal set_button(disabled)

var rng = RandomNumberGenerator.new()

onready var frog = get_node("Frog")
onready var gator = get_node("Gator")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	#here is where the player is
	set_cell(8,3,2)
	#here is where the enemy is
	set_cell(13,-2,1)
	
func enemy_turn():
	#Check Player Attack
	var player_position = get_used_cells_by_id(2)[0]
	var enemy_position = get_used_cells_by_id(1)[0]
	var x_distance
	var y_distance
	if player_position[0] > enemy_position[0]:
		x_distance = player_position[0] - enemy_position[0]
	else:
		x_distance = enemy_position[0] - player_position[0]
	if player_position[1] > enemy_position[1]:
		y_distance = player_position[1] - enemy_position[1]
	else:
		y_distance = enemy_position[1] - player_position[1]
	if x_distance <= 1 and y_distance <= 1:
		emit_signal("player_get_hit",gator.dmg)
	else:
		#Enemy Movement
		#var player_position = get_used_cells_by_id(2)[0]
		#var enemy_position = get_used_cells_by_id(1)[0]
		#var x_distance
		#var y_distance
		var x_destination
		var y_destination
		#Rolling movement distance
		var random = int(rng.randf_range(1,7))
		#print(random)
		#Calculating distance between player and enemy
		if player_position[0] > enemy_position[0]:
			x_distance = player_position[0] - enemy_position[0]
		else:
			x_distance = enemy_position[0] - player_position[0]
		if player_position[1] > enemy_position[1]:
			y_distance = player_position[1] - enemy_position[1]
		else:
			y_distance = enemy_position[1] - player_position[1]
		#Deciding where to move the enemy (x)
		if random >= x_distance - 1:
			if player_position[0] > enemy_position[0]:
				x_destination = player_position[0]-1
			else:
				x_destination = player_position[0]+1
		else:
			if player_position[0] > enemy_position[0]:
				x_destination = enemy_position[0] + random
			else:
				x_destination = enemy_position[0] - random
		#Deciding where to move the enemy (y)
		if random >= y_distance - 1:
			if player_position[1] > enemy_position[1]:
				y_destination = player_position[1]-1
			else:
				y_destination = player_position[1]+1
		else:
			if player_position[1] > enemy_position[1]:
				y_destination = enemy_position[1] + random
			else:
				y_destination = enemy_position[1] - random
		#Update grid
		set_cellv(get_used_cells_by_id(1)[0],-1)
		set_cell(x_destination,y_destination,1)
		var move_vector = Vector2(x_destination,y_destination)
		emit_signal("enemy_moved",map_to_world(move_vector))

#this function is called when the player's button is pressed
func _on_Button_pressed():
	if has_node("Frog") and frog.hp > 0:
		var player_position = get_used_cells_by_id(2)[0]
	#	print(player_position)
	#	print(player_position[0])
		var random = int(rng.randf_range(1,7))
	#	print(random)
	#	var random = 4
		for n in range(player_position[0]-random,player_position[0]+random+1):
			for m in range(player_position[1]-random,player_position[1]+random+1):
	#			print(n,", ",m)
				if get_cell(n,m) == -1 and n>=7 and n<=14 and m<=4 and m>=-3:
					set_cell(n,m,0)

func _input(event):
	if event.is_action_pressed("click"):
		var mouse_position = get_global_mouse_position()
		var tile = world_to_map(mouse_position)
		if get_cellv(tile) == 0:
			for n in get_used_cells_by_id(0):
				set_cellv(n,-1)
			set_cellv(get_used_cells_by_id(2)[0],-1)
			set_cellv(tile,2)
			fight_button_active()
			emit_signal("move_tile_clicked",map_to_world(tile))

func _on_Frog_frog_moved():
	if has_node("Gator") and gator.hp > 0:
		enemy_turn()
	fight_button_active()
	
func fight_button_active():
	var player_position = get_used_cells_by_id(2)[0]
	var enemy_position = get_used_cells_by_id(1)[0]
	var x_distance
	var y_distance
	if player_position[0] > enemy_position[0]:
		x_distance = player_position[0] - enemy_position[0]
	else:
		x_distance = enemy_position[0] - player_position[0]
	if player_position[1] > enemy_position[1]:
		y_distance = player_position[1] - enemy_position[1]
	else:
		y_distance = enemy_position[1] - player_position[1]
	if x_distance <= 1 and y_distance <= 1:
		emit_signal("set_button",false)
	else:
		emit_signal("set_button",true)

func _on_TextureButton_pressed():
	if has_node("Frog") and frog.hp > 0:
		emit_signal("enemy_get_hit",frog.dmg)
		if has_node("Gator") and gator.hp > 0:
			enemy_turn()
