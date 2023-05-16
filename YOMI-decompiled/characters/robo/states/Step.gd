extends RobotState

const MOVE_AMOUNT = 15



export  var charged = false



func _ready():
	pass
func _enter():
	if host.reverse_state:
		backdash_iasa = true
		beats_backdash = false
	else :
		backdash_iasa = false
		beats_backdash = true

func _frame_6():
	self_interruptable = false
	next_state_on_hold = false
	next_state_on_hold_on_opponent_turn = false
	host.move_directly_relative(MOVE_AMOUNT, 0)




func _frame_8():
	host.play_sound("Step")
	

func _frame_9():
	self_interruptable = true
	next_state_on_hold = true
	next_state_on_hold_on_opponent_turn = true
	var camera = host.get_camera()
	if camera:
		camera.bump(Vector2.UP, 10, 6 / 60.0)

func _tick():
	if charged:
		host.apply_forces_no_limit()
	else :
		host.apply_forces()
	pass
