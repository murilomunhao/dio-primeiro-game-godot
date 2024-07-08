extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elepsed_string: String
var life_core_counter: int = 0
var life_precious_counter: int = 0
var kill_enemies_counter: int = 0

func _process(delta: float):
	# Update timer
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	time_elepsed_string = "%02d:%02d" % [minutes,seconds]
	
func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	time_elapsed = 0.0
	time_elepsed_string = "00:00"
	life_core_counter = 0
	life_precious_counter = 0
	kill_enemies_counter = 0
	for connetion in game_over.get_connections():
		game_over.disconnect(connetion.callable)
