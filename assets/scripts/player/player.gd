extends CharacterBody3D
class_name Player

@export_group("Speed")
@export var walk_speed = 8.0
@export var sprint_speed = 12.0
@export var air_speed = 9.0
@export var slide_speed = 8.0

@export var walk_deccel = 0.9
@export var sprint_deccel = 0.8
@export var air_deccel = 0.4
@export var slide_deccel = 0.005

@export var walk_accel = 8.0
@export var sprint_accel = 8.0
@export var air_accel = 4.0
@export var slide_accel = 8.0

@export_group("Vault")
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@export_group("Vault")
@export var vault_v_move_time := 0.2
#@export var vault_h_move_time := 0.0

var gravity = 19.8
var was_sprinting : bool = false

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak)# * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))# * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))# * -1.0

@onready var player_collision : CollisionShape3D = $PlayerCollision
@onready var player_collision_slide : CollisionShape3D = $PlayerCollisionSlide

@onready var camera_mount : Node3D = $CameraMount
@onready var visuals : Node3D = $Visuals

@onready var player_state_chart : StateChart = $PlayerStateChart
@onready var vault_state : CompoundState = $PlayerStateChart/Movement/Vault

@onready var animation_tree : AnimationTree = $AnimationTree

@onready var body_cast = $Visuals/BodyCast
@onready var head_cast = $Visuals/HeadCast

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	# Camera Movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * Options.sensitivity.x))
		visuals.rotate_y(deg_to_rad(event.relative.x * Options.sensitivity.x))
		camera_mount.rotate_x(deg_to_rad(event.relative.y * Options.sensitivity.y))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(45))


func _process(_delta):
	pass


func _physics_process(_delta):
	pass


func look_towards(node: Object, vector, delta, smooth_speed:= 1.0, return_only:= false):
	var smooth
	if smooth_speed == 0:
		smooth = false
	else:
		smooth = true
	if vector is Object:
		vector = vector.global_transform.origin
	elif !vector is Vector3:
		print("No target to look towards")
		get_tree().paused = true
		return
	var looker = Node3D.new()
	node.add_child(looker)
	#looker.look_at(vector, Vector3.UP)
	var finalRot = node.rotation_degrees + looker.rotation_degrees
	if return_only == true:
		return finalRot
	elif smooth == false:
		node.rotation_degrees = finalRot
	else:
		looker.look_at(vector, Vector3.UP)
		finalRot = node.rotation_degrees + looker.rotation_degrees
		node.rotation_degrees = lerp(node.rotation_degrees, finalRot, delta * smooth_speed)
	looker.queue_free()
	pass


func apply_gravity(delta, gravity_overide : float = get_gravity()):
	velocity.y += gravity_overide * delta


func get_gravity() -> float:
	return jump_gravity if velocity.y <= 0.0 else fall_gravity


func jump(force_overide : float = jump_velocity):
	velocity.y = force_overide


func can_climb():
	if not body_cast.is_colliding():
		return false
	
	if head_cast.is_colliding():
		return false
	
	return true


func decelerate(_delta, deccel : float = walk_deccel):
	velocity.x = lerp(velocity.x, 0.0, deccel)
	velocity.z = lerp(velocity.z, 0.0, deccel)


func walk(delta, speed : float = walk_speed, deccel : float = walk_deccel, accel : float = walk_accel):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left","move_right","move_foreward","move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		look_towards(visuals, position + direction, delta, 6.0)
		
		velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
	else:
		decelerate(delta, deccel)


func _on_player_state_chart_event_received(event):
	print(event)
