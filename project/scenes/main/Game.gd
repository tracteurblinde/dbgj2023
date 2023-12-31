extends Node3D

var intro_cam_finished: bool = false
var intro_dialog_finished: bool = false

@onready var GameCam: Camera3D = $Player.get_camera()
@onready var ThePlayer := $Player

var last_checkpoint: Node3D = null
const INTRO := "camera_intro2"

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.preload_timeline("dawnguard")
	Dialogic.preload_timeline("alphaflight")
	Dialogic.preload_timeline("nightwatch")
	Dialogic.preload_timeline("zeta")
	Dialogic.preload_timeline("omega")
	$Level/AnimationPlayer.play(INTRO, 0, false)
	$Level/AnimationPlayer.advance(0)
	$Level/AnimationPlayer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ThePlayer.transform.origin.y < -10:
		reset_player()


func transition_to_gamecam():
	if intro_cam_finished and intro_dialog_finished:
		GameCam.set_current(true)
		$Level/Camera3D.visible = false
		ThePlayer.active = true


func _on_ui_intro_finished():
	# TODO: Move into level script

	# Set the last position/rotation in the camera_intro animation to the position of the character camera
	var animation: Animation = $Level/AnimationPlayer.get_animation(INTRO)
	assert(animation != null)
	assert(animation.get_track_count() == 2)
	assert(animation.track_get_type(0) == Animation.TYPE_POSITION_3D)
	assert(animation.track_get_type(1) == Animation.TYPE_ROTATION_3D)
	var position_key_count: int = animation.track_get_key_count(0)
	var rotation_key_count: int = animation.track_get_key_count(1)

	var game_cam_position = GameCam.get_global_transform().origin
	var game_cam_rotation = GameCam.get_global_transform().basis.get_rotation_quaternion()

	animation.track_set_key_value(0, position_key_count - 1, game_cam_position)
	#animation.track_set_key_value(0, position_key_count - 2, game_cam_position)
	animation.track_set_key_value(1, rotation_key_count - 1, game_cam_rotation)
	#animation.track_set_key_value(1, rotation_key_count - 2, game_cam_rotation)

	$Level/AnimationPlayer.play(INTRO)
	Dialogic.start("dawnguard")


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == INTRO:
		intro_cam_finished = true
		transition_to_gamecam()


func _on_dialogic_signal(argument: String):
	if argument == "dawnguard_complete":
		intro_dialog_finished = true
		transition_to_gamecam()
	elif argument == "alphaflight_complete":
		ThePlayer.active = true
	elif argument == "nightwatch_complete":
		ThePlayer.active = true
	elif argument == "zeta_complete":
		ThePlayer.active = true
	elif argument == "omega_complete":
		ThePlayer.active = true


func reset_player():
	ThePlayer.global_transform.origin = last_checkpoint.global_transform.origin
	#ThePlayer.global_transform.basis = last_checkpoint.global_transform.basis
	ThePlayer.reset()
	ThePlayer.active = true


func _on_boundary_flat_hit(_flat: Node):
	if last_checkpoint != null:
		reset_player()


func _on_checkpoint(checkpoint: Node3D):
	last_checkpoint = checkpoint


func _on_alphaflight(_node: Node3D):
	Dialogic.start("alphaflight")
	ThePlayer.active = false


func _on_nightwatch(_node: Node3D):
	Dialogic.start("nightwatch")
	ThePlayer.active = false


func _on_zeta(_node: Node3D):
	Dialogic.start("zeta")
	ThePlayer.active = false


func _on_omega(_node: Node3D):
	Dialogic.start("omega")
	ThePlayer.active = false
