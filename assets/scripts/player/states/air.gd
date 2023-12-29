extends PlayerState

#Air State
func _on_air_state_physics_processing(delta):
	player.apply_gravity(delta)
	player.walk(delta, player.air_speed, player.air_deccel, player.air_accel)
	
	if player.is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_foreward") or Input.is_action_pressed("move_backward"):
			player.player_state_chart.send_event("walk")
		else:
			player.player_state_chart.send_event("idle")
	
	player.move_and_slide()
