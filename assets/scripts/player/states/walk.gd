extends PlayerState

#Walk State
func _on_walk_state_physics_processing(delta):
	player.apply_gravity(delta)
	player.walk(delta)
	
	if Input.is_action_just_pressed("move_jump"):
		player.player_state_chart.send_event("jump")
	
	if is_zero_approx(player.velocity.x) and is_zero_approx(player.velocity.z):
		player.player_state_chart.send_event("idle")
	
	if not player.is_on_floor():
		player.player_state_chart.send_event("fall")
	
	if player.can_climb() and Input.is_action_pressed("parkour_vault"):
		player.player_state_chart.send_event("vault")
	
	if Input.is_action_pressed("move_slide"):
		player.player_state_chart.send_event("slide")
	
	player.move_and_slide()
