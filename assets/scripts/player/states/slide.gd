extends PlayerState


func _on_slide_state_entered():
	player.velocity += -player.visuals.global_transform.basis.z * 20
	player.apply_gravity(0, player.get_gravity() * 16.0)
	player.player_collision.disabled = true
	player.player_collision_slide.disabled = false
	player.camera_mount.position.y -= 0.5


func _on_slide_state_physics_processing(delta):
	player.apply_gravity(delta, player.get_gravity() * 2.0)
	if player.is_on_floor():
		player.look_towards(player.visuals, player.position + player.velocity, delta, 6.0)
		player.visuals.rotation.x = lerp(player.visuals.rotation.x, -player.get_floor_angle(Vector3.UP), 0.5)
	else:
		player.look_towards(player.visuals, player.position + player.velocity, delta, 6.0)
	player.velocity.x = lerp(player.velocity.x, player.velocity.x + (player.get_floor_normal().x * 6.0), 1)
	player.velocity.z = lerp(player.velocity.z, player.velocity.z + (player.get_floor_normal().z * 6.0), 1)
	player.decelerate(delta, player.slide_deccel)
	
	if is_zero_approx(player.velocity.x) and is_zero_approx(player.velocity.z):
		player.player_state_chart.send_event("end")
	
	if Input.is_action_just_released("move_slide"):
		player.player_state_chart.send_event("stop")
	
	player.move_and_slide()


func _on_slide_state_exited():
	player.visuals.rotation.x = 0
	player.player_collision.disabled = false
	player.player_collision_slide.disabled = true
	player.camera_mount.position.y += 0.5
