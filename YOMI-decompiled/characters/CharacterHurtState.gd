extends CharacterState

class_name CharacterHurtState

const SMOKE_SPEED = "6.5"
const SMOKE_FREQUENCY = 1
const COUNTER_HIT_ADDITIONAL_HITSTUN_FRAMES = 5
const HITSTUN_DECAY_PER_HIT = 1
const DI_BRACE_RATIO = "-0.25"

var brace = false

enum BOUNCE{
	LEFT_WALL, 
	RIGHT_WALL, 
	NO_BOUNCE
}

var counter = false

var hitbox

func _enter_tree():
	is_hurt_state = true

func init():
	.init()
	busy_interrupt_into.append("Nudge")

func _enter_shared():
	brace = false
	host.release_opponent()
	hitbox = data["hitbox"]
	host.z_index = - 1
	if hitbox.disable_collision:
		host.colliding_with_opponent = false


	if host.penalty_ticks <= 0:
		host.refresh_air_movements()
	host.state_interruptable = true
	host.busy_interrupt = true
	host.clear_buffer()
	._enter_shared()

func _tick_shared():
	._tick_shared()
	if current_tick < 10:
		host.release_opponent()
	if current_tick % SMOKE_FREQUENCY == 0:
		var vel = host.get_vel()
		if fixed.gt(fixed.vec_len(vel.x, vel.y), SMOKE_SPEED):
			spawn_particle_relative(preload("res://fx/KnockbackSmoke.tscn"), host.hurtbox_pos_relative_float())

func hitstun_modifier(hitbox):
	return (COUNTER_HIT_ADDITIONAL_HITSTUN_FRAMES if hitbox.counter_hit else 0)


func global_hitstun_modifier(ticks):
	return fixed.round(fixed.mul(str(ticks), host.global_hitstun_modifier))

func di_shave_hitstun(hitstun, hitbox_dir_x, hitbox_dir_y):








	return hitstun

func get_x_dir(hitbox):
	return host.get_hitbox_x_dir(hitbox)

func _on_hit_something(_obj, _hitbox):
	pass

func _exit_shared():
	host.z_index = 0
	brace = false
	._exit_shared()

func can_interrupt():
	return false
