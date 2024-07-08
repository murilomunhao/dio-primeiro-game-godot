extends Node2D

@export var regeneration_amount: int = 10
@onready var life_itens = self

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	if life_itens.is_in_group("heals_level_1"):
		regeneration_amount = 5
	elif life_itens.is_in_group("heals_level_2"):
		regeneration_amount = 10
	else:
		regeneration_amount = 1

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		player.life_collected.emit(regeneration_amount)
		queue_free()
