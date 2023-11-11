extends Control

func _ready():
	$AnimationPlayer.play("fade_godot")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_godot":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
