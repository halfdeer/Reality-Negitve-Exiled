extends PlayerState


#Vault
func _on_vault_state_entered():
	await player.animation_tree.animation_started
	player.velocity = Vector3.ZERO
	# Vertical Transforms
	var vertical_movement = player.global_transform.origin + Vector3(0,3.315,0)
	var vm_tween = get_tree().create_tween()
	
	vm_tween.tween_property(self, "player:global_transform:origin", vertical_movement, player.vault_v_move_time)
	
	await vm_tween.finished
	
	# Horizontal Transforms
	var forward_movement = -player.visuals.global_transform.basis.z * 20
	player.velocity = forward_movement
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_foreward") or Input.is_action_pressed("move_backward"):
			player.player_state_chart.send_event("walk")
	else:
			player.player_state_chart.send_event("idle")


func _on_vault_state_physics_processing(_delta):
	player.move_and_slide()
