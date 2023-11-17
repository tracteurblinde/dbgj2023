extends StaticBody3D

signal hit


func _on_area_3d_body_entered(body: Node):
	var parent := body.get_parent()
	emit_signal("hit", parent)
