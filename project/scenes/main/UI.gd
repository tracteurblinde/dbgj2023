extends Control

signal intro_finished
signal anykey_pressed

var has_pressed_anykey: bool = false


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			_on_anykey_pressed()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			_on_anykey_pressed()


func _on_anykey_pressed():
	if has_pressed_anykey:
		return

	has_pressed_anykey = true
	emit_signal("anykey_pressed")
	$AnimationPlayer.play("fade_intro")


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("intro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "fade_intro":
		emit_signal("intro_finished")
