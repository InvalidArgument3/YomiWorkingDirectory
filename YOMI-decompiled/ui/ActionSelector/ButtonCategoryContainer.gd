extends Control

class_name ButtonCategoryContainer

signal prediction_selected()

const BOX_SIZE = 52
const DEFAULT_HEIGHT = 60

onready var action_data_container = $"%ActionDataContainer"
onready var action_data_panel_container = $"%ActionDataPanelContainer"
onready var button_container = $"%ButtonContainer"

var label_text = ""
var selected_button_text = ""
var active_button = null

var mouse_over = false
var can_update = true

var game = null
var player_id = null

var category_int = - 1

var prediction_type = null

func init(name):
	label_text = name
	$"%Label".text = label_text







func any_buttons_visible():
	for button in $"%ButtonContainer".get_children():
		if button.visible:
			return true
	return false

func _process(_delta):






	if not mouse_over and can_update and Utils.is_mouse_in_control(self):
		$"%ScrollContainer".rect_clip_content = false
		$"%ScrollContainer".rect_min_size.y = $"%ButtonContainer".rect_size.y
		rect_size.y = 1000
		mouse_over = true
		can_update = false
		$UpdateTimer.start()

		call_deferred("set_pos_y", - $"%ScrollContainer".rect_min_size.y + BOX_SIZE)
	
	elif mouse_over and can_update and not Utils.is_mouse_in_control(self):
		$"%ScrollContainer".rect_clip_content = true
		$"%ScrollContainer".rect_min_size.y = BOX_SIZE
		rect_size.y = DEFAULT_HEIGHT
		call_deferred("set_pos_y", 0)
		mouse_over = false
		can_update = false
		$UpdateTimer.start()

func set_pos_y(y):
	rect_position.y = y









func enable_predict_button():
	$"%PredictButton".show()


func disable_predict_button():

	$"%PredictButton".hide()

func add_button(button):
	$"%ButtonContainer".add_child(button)
	button.connect("mouse_entered", self, "on_button_mouse_entered", [button])
	button.connect("mouse_exited", self, "on_button_mouse_exited")

func get_prediction():
	return $"%PredictButton".pressed and $"%PredictButton".visible

func reset_prediction():
	$"%PredictButton".set_pressed_no_signal(false)

func refresh():
	if get_prediction():
		$"%Label".text = label_text
		$"%Label".modulate = Color.white
		$"%Label".modulate.a = 1.0
		return 
	for button in $"%ButtonContainer".get_children():
		if button.is_pressed():
			on_button_mouse_entered(button)
			$"%Label".modulate = Color.cyan
			active_button = button
			selected_button_text = button.action_title
			return 
	$"%Label".text = label_text
	$"%Label".modulate = Color.white
	$"%Label".modulate.a = 0.25

func on_button_mouse_entered(button):
	if get_prediction():
		return 
	_on_ButtonContainer_mouse_entered()
	$"%Label".text = button.action_title
	if button.action_title == selected_button_text:
		return 
	$"%Label".modulate = Color.green

func on_button_mouse_exited():
	refresh()

func show_data_container():
	$"%ActionDataPanelContainer".show()



	
func hide_data_container():
	$"%ActionDataPanelContainer".hide()
















func _on_ButtonContainer_mouse_entered():


	pass

func _on_ButtonContainer_mouse_exited():


	pass


func _on_PredictButton_mouse_entered():
	$"%PredictLabel".show()
	$"%PredictLabel".text = "P" + str((player_id % 2) + 1) + " Prediction"
	pass


func _on_PredictButton_mouse_exited():
	$"%PredictLabel".hide()
	pass


func _on_PredictButton_pressed():
	refresh()
	emit_signal("prediction_selected")
	pass


func _on_UpdateTimer_timeout():
	can_update = true
	pass
