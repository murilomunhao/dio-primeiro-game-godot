class_name MobisEnemies
extends Node


var speed: float = 0.0
var enemy: Enemy
var sprite: AnimatedSprite2D 

func _ready():
	enemy = get_parent()
	if enemy.is_in_group("enemies_level_1"):
		speed = 2.2
	elif enemy.is_in_group("enemies_level_2"):
		speed = 1.5
	elif enemy.is_in_group("enemies_level_3"):
		speed = 1.1
	else:
		speed = 1.0
	
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:
	if GameManager.is_game_over: return
	
	#Calcular direção
	var player_position =  GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	# Movimento
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	
	# Inverte a direção da animação .
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
