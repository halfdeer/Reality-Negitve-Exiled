extends PlayerState

func _on_idle_state_entered():
	player.was_sprinting = false


#Idle State
func _on_idle_state_processing(delta):
	player.apply_gravity(delta)
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_foreward") or Input.is_action_pressed("move_backward"):
		player.player_state_chart.send_event("walk")
	
	if Input.is_action_just_pressed("move_jump"):
		player.player_state_chart.send_event("jump")
	
	player.decelerate(delta)
	
	player.move_and_slide()
