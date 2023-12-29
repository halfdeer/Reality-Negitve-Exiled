extends PlayerState

#Jump State
func _on_jump_state_entered():
	player.jump()


func _on_jump_state_physics_processing(delta):
	player.apply_gravity(delta)
	player.walk(delta, player.air_speed, player.air_deccel, player.air_accel)
	
	if player.velocity.y <= 0:
		player.player_state_chart.send_event("air")
	
	player.move_and_slide()
