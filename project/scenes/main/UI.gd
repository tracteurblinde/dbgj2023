extends Control

signal intro_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("intro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "intro":
		emit_signal("intro_finished")
