extends KinematicBody2D

export (int) var speed = 200

var target = Vector2(80,95)
var velocity = Vector2()

func _input(event):
	if event.is_action_pressed("click"):
		var mouse_position = get_global_mouse_position()
		var x_remainder = fmod(mouse_position.x,float(32))
		var y_remainder = fmod(mouse_position.y,float(16))
		target.x = mouse_position.x - x_remainder + 20
		target.y = mouse_position.y - y_remainder - 1
		print(target)

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	# look_at(target)
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
