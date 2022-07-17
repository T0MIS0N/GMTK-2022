extends KinematicBody2D

export (int) var speed = 200

var target = Vector2(240,96)
var velocity = Vector2()
var rng = RandomNumberGenerator.new()
var maxHp
var hp
var dmg

onready var sprite = get_node("Gator")
onready var health_bar = get_node("EnemyHealthBar/Bar")

func _ready():
	rng.randomize()
	hp = int(rng.randf_range(1,7))
	maxHp = hp
	dmg = int(rng.randf_range(1,7))

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	look_dir(velocity)
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
	else:
		position = target

func look_dir(velocity):
	if velocity.x > 0:
		get_node("Gator").flip_h = true
	elif velocity.x < 0:
		get_node("Gator").flip_h = false


func _on_GridObjects_enemy_moved(position):
	target.x = position.x
	target.y = position.y + 8


func _on_GridObjects_enemy_get_hit(damage):
	if damage < hp:
		hp -= damage
	elif damage >= hp:
		hp = 0
		queue_free()
	print(hp,", ",maxHp,", ",damage)
	var length = float(float(hp)/float(maxHp))
	health_bar.scale.x = length
