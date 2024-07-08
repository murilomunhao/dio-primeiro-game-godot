extends CanvasLayer

@onready var timer_label: Label = %TimeLabel
@onready var precious_label: Label = %PreciousLabel
@onready var core_label: Label = %CoreLabel
@onready var kills_label: Label = %KillsLabel


	
func _process(delta: float):
	# Update timer
	timer_label.text = GameManager.time_elepsed_string
	core_label.text = str(GameManager.life_core_counter)
	precious_label.text = str(GameManager.life_precious_counter)
	kills_label.text = str(GameManager.kill_enemies_counter)



