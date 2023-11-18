extends StaticBody3D

signal hit


func _on_area_3d_body_entered(body: Node):
	if not body.is_in_group("player"):
		return
	var parent := body.get_parent()
	emit_signal("hit", parent)
	
