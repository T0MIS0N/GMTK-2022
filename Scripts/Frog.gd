extends KinematicBody2D

signal frog_moved()
signal take_damage(health,max_health)

export (int) var speed = 200

var target = Vector2(80,95)
var velocity = Vector2()
var rng = RandomNumberGenerator.new()
var maxHp
var hp
var dmg

onready var sprite = get_node("Frog")

func _ready():
	rng.randomize()
	hp = 4 + int(rng.randf_range(1,7))
	maxHp = hp
	dmg = int(rng.randf_range(1,7))

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	look_dir(velocity)
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
	elif position.distance_to(target) <= 5 and position.distance_to(target) > 0:
		position = target
		emit_signal("frog_moved")
	else:
		pass
		

func _on_GridObjects_move_tile_clicked(position):
	target.x = position.x
	target.y = position.y + 7

func look_dir(velocity):
	if velocity.x < 0:
		get_node("Frog").flip_h = true
	elif velocity.x > 0:
		get_node("Frog").flip_h = false

func _on_GridObjects_player_get_hit(damage):
	if damage < hp:
		hp -= damage
	elif damage >= hp:
		hp = 0
		queue_free()
	print(hp,", ",maxHp,", ",damage)
	emit_signal("take_damage",hp,maxHp)
