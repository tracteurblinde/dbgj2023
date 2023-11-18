@tool
extends Node3D

@export var reverse: bool = false:
	set = set_reverse


func _ready():
	$AnimationPlayer.play("spin_3")
	set_reverse(reverse)


func _physics_process(_delta):
	# The AnimatedBody3D only does the right thing if the animation touches the local transform.
	# Since we're rotating the pivot, we need to touch the local transform so the setter gets called.
	$pivot/zeta_platform.transform = $pivot/zeta_platform.transform
	$pivot/zeta_platform2.transform = $pivot/zeta_platform2.transform
	$pivot/zeta_platform3.transform = $pivot/zeta_platform3.transform


func set_reverse(value: bool):
	$AnimationPlayer.speed_scale = -1 if value else 1
	#$AnimationPlayer.play("spin_3")
	reverse = value
