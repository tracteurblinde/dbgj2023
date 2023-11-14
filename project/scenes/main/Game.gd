extends Node3D

var intro_cam_finished: bool = false
var intro_dialog_finished: bool = false

@onready var GameCam: Camera3D = $Player.get_camera()


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func transition_to_gamecam():
	if intro_cam_finished and intro_dialog_finished:
		GameCam.set_current(true)
		$Level/Camera3D.visible = false
		$Player.active = true


func _on_ui_intro_finished():
	# TODO: Move into level script

	# Set the last position/rotation in the camera_intro animation to the position of the character camera
	var animation: Animation = $Level/AnimationPlayer.get_animation("camera_intro")
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

	$Level/AnimationPlayer.play("camera_intro")
	Dialogic.start("test")


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "camera_intro":
		intro_cam_finished = true
		transition_to_gamecam()


func _on_dialogic_signal(argument: String):
	if argument == "intro_complete":
		intro_dialog_finished = true
		transition_to_gamecam()