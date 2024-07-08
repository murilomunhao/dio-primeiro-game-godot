class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monsters_label: Label = %MonstersLabel
@onready var diamond_label: Label = %DiamondLabel
@onready var hearts_label: Label = %HeartsLabel


@export var restart_delay: float = 5.0
var restart_cooldown: float


func _ready():
	time_label.text = GameManager.time_elepsed_string
	monsters_label.text = str(GameManager.kill_enemies_counter)
	diamond_label.text = str(GameManager.life_precious_counter)
	hearts_label.text = str(GameManager.life_core_counter)
	restart_cooldown = restart_delay

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
		
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
