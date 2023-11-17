extends CharacterBody3D

const LERP_VALUE: float = 0.15

var snap_vector: Vector3 = Vector3.DOWN
var speed: float
@export var active: bool = false
@export var enable_double_jump: bool = true
@export var enable_dash: bool = true

var frames_processed = 0
var num_jumps = 0
@export var max_jumps = 2

@export_group("Movement variables")
@export var walk_speed: float = 4.0
@export var run_speed: float = 10.0
@export var jump_strength: float = 30.0
@export var dash_strength: float = 2.0
@export var dash_length: float = 0.3
@export var gravity: float = 60.0

@export_group("Input Variables")
@export var combo_timeout: float = 0.3

const ANIMATION_BLEND: float = 7.0

@onready var player_mesh: Node3D = $Model
@onready var spring_arm_pivot: Node3D = $SpringArmPivot
@onready var animator: AnimationTree = $AnimationTree

var last_w_delta: float = 0.0
var looking_for_combo: bool = false
var dash_remaining: float = 0.0


func is_active():
	return active

func is_dashing():
	return dash_remaining > 0.0

func _physics_process(delta):
	if not active:
		return

	frames_processed += 1

	var dashing := false
	if enable_dash:
		if Input.is_action_just_pressed("move_forward"):
			if not looking_for_combo:
				looking_for_combo = true
				last_w_delta = 0.0
			else:
				looking_for_combo = false
				if last_w_delta < combo_timeout:
					print("Dash")
					animator.set(
						"parameters/roll_oneshot/request",
						AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
					)
					dash_remaining = dash_length
					looking_for_combo = false
					last_w_delta = 0.0
				else:
					last_w_delta = 0.0
					looking_for_combo = true

		if looking_for_combo:
			last_w_delta += delta

		if dash_remaining > 0.0:
			dashing = true
			dash_remaining -= delta
		else:
			dash_remaining = 0.0

	var move_direction: Vector3 = Vector3.ZERO
	move_direction.x = (
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	)
	move_direction.z = (
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	)
	move_direction = move_direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)

	velocity.y -= gravity * delta

	if dashing:
		speed = run_speed * dash_strength
	elif Input.is_action_pressed("move_walk"):
		speed = walk_speed
	else:
		speed = run_speed

	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed

	if move_direction:
		player_mesh.rotation.y = lerp_angle(
			player_mesh.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VALUE
		)

	var just_landed := is_on_floor() and snap_vector == Vector3.ZERO
	var is_jumping := false
	if enable_double_jump:
		is_jumping = Input.is_action_just_pressed("move_jump") and num_jumps < max_jumps
	else:
		is_jumping = Input.is_action_just_pressed("move_jump") and is_on_floor()
	if is_jumping:
		velocity.y = jump_strength
		snap_vector = Vector3.ZERO
		print("Jumping")
		if num_jumps > 0:
			animator.set(
				"parameters/flip_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			)
		num_jumps += 1

	elif just_landed:
		snap_vector = Vector3.DOWN
		num_jumps = 0

	apply_floor_snap()
	move_and_slide()

	# Ignore the first couple frames to avoid a weird animation glitch
	if frames_processed > 2:
		animate(delta)


func animate(delta):
	if is_on_floor():
		animator.set("parameters/ground_air_transition/transition_request", "grounded")

		if velocity.length() > 0:
			if speed == run_speed:
				animator.set(
					"parameters/iwr_blend/blend_amount",
					lerp(
						animator.get("parameters/iwr_blend/blend_amount"),
						1.0,
						delta * ANIMATION_BLEND
					)
				)
			else:
				animator.set(
					"parameters/iwr_blend/blend_amount",
					lerp(
						animator.get("parameters/iwr_blend/blend_amount"),
						0.0,
						delta * ANIMATION_BLEND
					)
				)
		else:
			animator.set(
				"parameters/iwr_blend/blend_amount",
				lerp(
					animator.get("parameters/iwr_blend/blend_amount"), -1.0, delta * ANIMATION_BLEND
				)
			)
	else:
		animator.set("parameters/ground_air_transition/transition_request", "air")


func get_camera():
	return spring_arm_pivot.get_node("SpringArm3D/Camera3D")
