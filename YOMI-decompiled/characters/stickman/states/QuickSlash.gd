extends SuperMove

const MOVE_DISTANCE = 120
const NEUTRAL_STARTUP_LAG = 3
const LANDING_LAG = 2
const IASA = 20
const WHIFF_LANDING_LAG = 8
const WHIFF_IASA = 40

var hitboxes = []

var dist = MOVE_DISTANCE

var startup_lag = 0
var landing_lag = LANDING_LAG

var started_in_neutral = false

func _enter():
	dist = MOVE_DISTANCE
	hitboxes = []
	for child in get_children():
		if child is Hitbox:
			hitboxes.append(child)
			child.x = 0
			child.y = 0
	var move_dir
	if data:
		move_dir = xy_to_dir(data.x, data.y)

	else :
		move_dir = {"x":str(host.get_facing_int()), "y":"0"}
	var move_vec = fixed.normalized_vec_times(move_dir.x, move_dir.y, "20")

	host.apply_force(move_vec.x, fixed.div(move_vec.y, "2"))
	host.quick_slash_move_dir_x = move_dir.x
	host.quick_slash_move_dir_y = move_dir.y































func _frame_0():
	started_in_neutral = host.combo_count <= 0
	iasa_at = WHIFF_IASA
	landing_lag = WHIFF_LANDING_LAG


func _frame_1():
	var start_pos = host.get_pos().duplicate()
	host.quick_slash_start_pos_x = start_pos.x
	host.quick_slash_start_pos_y = start_pos.y

func _frame_4():
	if host.initiative:
		host.start_invulnerability()


func _frame_5():
	host.move_directly(0, - 2)

	var move_dir_x = host.quick_slash_move_dir_x
	var move_dir_y = host.quick_slash_move_dir_y

	var move_vec = fixed.normalized_vec_times(move_dir_x, move_dir_y, str(MOVE_DISTANCE))


	host.move_directly(move_vec.x, move_vec.y)
	host.update_data()
	
	var start_pos_x = host.quick_slash_start_pos_x
	var start_pos_y = host.quick_slash_start_pos_y
	
	var end_pos = host.get_pos().duplicate()
	
	move_vec.x = end_pos.x - start_pos_x
	move_vec.y = end_pos.y - start_pos_y
	var pos = host.get_pos_visual()
	var particle_dir = Vector2(float(move_vec.x), float(move_vec.y)).normalized()
	host.spawn_particle_effect(preload("res://characters/stickman/QuickSlashEffect.tscn"), Vector2(start_pos_x, start_pos_y - 13), particle_dir)
	host.update_data()

func _frame_6():
	var start_pos_x = host.quick_slash_start_pos_x
	var start_pos_y = host.quick_slash_start_pos_y
	
	var end_pos = host.get_pos().duplicate()
	if start_pos_x != null and start_pos_y != null and end_pos.x != null and end_pos.y != null:
		for i in range(hitboxes.size()):
			var ratio = fixed.div(str(i), str(hitboxes.size()))
			hitboxes[i].x = fixed.round(fixed.sub(fixed.lerp_string(str(start_pos_x), str(end_pos.x), ratio), str(host.get_pos().x))) * host.get_facing_int()
			hitboxes[i].y = fixed.round(fixed.sub(fixed.lerp_string(str(start_pos_y), str(end_pos.y), ratio), str(host.get_pos().y))) - 16
	
	var move_dir_x = host.quick_slash_move_dir_x
	var move_dir_y = host.quick_slash_move_dir_y


	host.reset_momentum()
	var move_vec = fixed.normalized_vec_times(move_dir_x, move_dir_y, "10")
	host.apply_force(move_dir_x, fixed.mul(move_dir_y, "1.0"))
	host.apply_force("0", "-1")










	host.end_invulnerability()

func can_hit_cancel():
	return host.combo_count > 1 or not host.opponent.is_grounded()

func _got_parried():
	host.hitlag_ticks += 10
	host.reset_momentum()
	pass

func _on_hit_something(obj, hitbox):
	iasa_at = IASA
	landing_lag = LANDING_LAG
	._on_hit_something(obj, hitbox)

func _tick():






	if current_tick > 6:
		if host.is_grounded():
			queue_state_change("Landing", landing_lag)
	host.apply_grav()

	host.apply_forces_no_limit()
