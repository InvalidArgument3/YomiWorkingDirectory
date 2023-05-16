extends "res://characters/stickman/projectiles/fireball_states/Default.gd"

const ROTATE_AMOUNT = 22.5

func _tick():
	._tick()
	host.sprite.rotation += deg2rad(ROTATE_AMOUNT) * host.get_facing_int()

func move():


		var dir = fixed.vec_mul(host.dir_x, host.dir_y, data.speed_modifier)
		host.move_directly_relative(dir.x, dir.y)


