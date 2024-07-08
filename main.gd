extends Node2D


@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
@onready var audio_stream_player = $AudioStreamPlayer



func _ready():
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	audio_stream_player.stop()
	# Deletar  GameUI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	# Criar GameOverUI
	var game_over_ui = game_over_ui_template.instantiate()
	add_child(game_over_ui)
