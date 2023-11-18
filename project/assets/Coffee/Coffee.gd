@tool
extends Node3D

signal spawn
signal collected

var been_collected := false

func _ready():
	$AnimationPlayer.play("idle")
	if not Engine.is_editor_hint():
		emit_signal("spawn")

func _on_area_3d_body_entered(body: Node3D):
	if been_collected:
		return
	if body.is_in_group("player"):
		emit_signal("collected")
		$AnimationPlayer.play("collected")
		been_collected = true