extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_ui_intro_finished():
	$AnimationPlayer.play("camera_intro")
	
	Dialogic.start("test")