extends Control

@export_file var MENU_SCENE: String = "res://scenes/main.tscn"

func _ready():
	$AnimationPlayer.play("fade_godot")
	ResourceLoader.load_threaded_request(MENU_SCENE)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_godot":
		var menu = ResourceLoader.load_threaded_get(MENU_SCENE)
		get_tree().change_scene_to_packed(menu)
