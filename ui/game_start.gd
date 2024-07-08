extends CanvasLayer


func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://ui/game_loading.tscn")
	



func _on_button_exit_pressed():
	get_tree().quit()
