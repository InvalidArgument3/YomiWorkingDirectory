extends VBoxContainer

func _ready():
	$"%P1ActionButtons".connect("visibility_changed", self, "_on_action_buttons_visibility_changed")
	$"%P2ActionButtons".connect("visibility_changed", self, "_on_action_buttons_visibility_changed")
	$"%P1ActionButtons".opposite_buttons = $"%P2ActionButtons"
	$"%P2ActionButtons".opposite_buttons = $"%P1ActionButtons"

func _on_action_buttons_visibility_changed():
	if not $"%P1ActionButtons".visible and not $"%P2ActionButtons".visible:
		$"%OptionsBarContainer".hide()
		$"%PredictionSettingsOpenButton".hide()
	else :
		$"%OptionsBarContainer".show()
		if not $"%OptionsBar".visible:
			$"%PredictionSettingsOpenButton".show()
		else :
			$"%PredictionSettingsOpenButton".hide()
