extends Node2D


var max_dist = 400
var dir = Vector2(1, 0)
var vel = 500
var thrower
var damage = 1

enum {FORWARD, BACKWARDS}
var status = FORWARD

onready var init_pos = global_position

func _ready():
	pass # Replace with function body.

func set_p_direction(direction):
	dir = direction
	if direction == Vector2(-1, 0):
		$AnimatedSprite.flip_h = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status == FORWARD:
		translate(dir * vel * delta)
		$AnimatedSprite.play("mov")
		if global_position.distance_to(init_pos) > max_dist:
			status = BACKWARDS
	elif status == BACKWARDS:
		var ret_point
		if thrower != null:
			ret_point = thrower.global_position
		else:
			ret_point = init_pos
		var ret_dir = (ret_point - global_position).normalized()
		translate(ret_dir * vel * delta)
		$AnimatedSprite.flip_h = true
		if global_position.distance_to(ret_point) < 10:
			queue_free()
			get_parent().get_node("Character").boomerang_count -= 1


func _on_DamageArea_body_entered(body):
	if "enemy" in body.name:
		body.damage(damage)
	if status == FORWARD:
		if body.name != "Character" and not("enemy" in body.name):
			status = BACKWARDS
