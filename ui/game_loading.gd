extends CanvasLayer


func _on_background_mouse_entered():
	get_tree().change_scene_to_file("res://main.tscn")
