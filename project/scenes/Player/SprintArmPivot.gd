extends Node3D

@export_group("FOV")
@export var change_fov_on_run: bool
@export var normal_fov: float = 75.0
@export var run_fov: float = 90.0

const CAMERA_BLEND: float = 0.05

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
var player: CharacterBody3D = null

var is_mouse_captured: bool = false


func _ready():
	player = get_parent()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if not is_mouse_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				is_mouse_captured = true
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				is_mouse_captured = false

	if !player.is_active():
		return

	if event is InputEventMouseMotion and is_mouse_captured:
		rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI / 4, PI / 4)


func _input(_event):
	# If ui_cancel is pressed, release the mouse if it's captured
	if Input.is_action_just_pressed("ui_cancel"):
		if is_mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_mouse_captured = false


func _physics_process(_delta):
	if !player.is_active():
		return

	if change_fov_on_run:
		if owner.is_on_floor():
			if Input.is_action_pressed("walk"):
				camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
			else:
				camera.fov = lerp(camera.fov, run_fov, CAMERA_BLEND)
		else:
			camera.fov = lerp(camera.fov, run_fov, CAMERA_BLEND)
