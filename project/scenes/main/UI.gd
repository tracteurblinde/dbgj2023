extends Control

signal intro_finished
signal anykey_pressed

var has_pressed_anykey := false
var has_fade_in_completed := false

var coffee_count := 0
var coffee_max := 0


func _ready():
	$AnimationPlayer.play("intro")


func _input(event):
	if has_fade_in_completed and event is InputEventKey:
		if event.pressed:
			_on_anykey_pressed()


func _unhandled_input(event):
	if has_fade_in_completed and event is InputEventKey:
		if event.pressed:
			_on_anykey_pressed()


func _on_anykey_pressed():
	if has_pressed_anykey:
		return

	has_pressed_anykey = true
	emit_signal("anykey_pressed")
	$AnimationPlayer.play("fade_intro")


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "intro":
		has_fade_in_completed = true
	elif anim_name == "fade_intro":
		emit_signal("intro_finished")


func _on_coffee_spawn():
	coffee_max += 1
	$Score/Total.text = "/" + str(coffee_max)


func _on_coffee_collected():
	coffee_count += 1
	$Score/Collected.text = str(coffee_count).pad_zeros(2)
