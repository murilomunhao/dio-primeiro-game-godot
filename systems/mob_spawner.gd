class_name MobSpawner
extends Node2D

#________________________________________________________________#
@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var mobs_per_minutes: float = 60.0
var mobs_level_1: float = 120.0
var mobs_level_2: float = 30.0
var mobs_level_3: float = 6.0

var creatures: Array[PackedScene] = []
var cooldown: float = 0.0
#________________________________________________________________#

func _ready():
	load_creatures()
	
func _process(delta: float):
	if GameManager.is_game_over: return
	
	# Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Checar se o ponto é válido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	# Instanciar uma criatura aleatura
	var index = randi_range(0, creatures.size() -1 )
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
	
# Verificar o nível do inimigo e definir o intervalo
	var interval = get_interval(creature)
	print("Intervalo calculado: ", interval)
	cooldown = interval
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position

func get_interval(creature: Node2D) -> float:
	if creature.is_in_group("enemies_level_1"):
		if mobs_level_1 <= 0:
			mobs_level_1 = 1.0
		print("Nivel 1 criatura instanciada. Intervalo:", 60.0 / mobs_level_1)
		return 60.0 / mobs_level_1 
	elif creature.is_in_group("enemies_level_2"):
		if mobs_level_2 <= 0:
			mobs_level_2 = 1.0
		print("Nivel 2 criatura instanciada. Intervalo:", 60.0 / mobs_level_2)
		return 60.0 / mobs_level_2 
	elif creature.is_in_group("enemies_level_3"):
		if mobs_level_3 <= 0:
			mobs_level_3 = 1.0
		print("Nivel 3 criatura instanciada. Intervalo:", 60.0 / mobs_level_3)
		return 60.0 / mobs_level_3 
		print("Criatura padrão instanciada. Intervalo:", 60.0 / mobs_per_minutes)
	return 60.0 / mobs_per_minutes # Valor padrão caso não esteja em nenhum grupo específico
	
func load_creatures() -> void:
	creatures.append(load("res://enemies/bat.tscn"))
	creatures.append(load("res://enemies/demo.tscn"))
	creatures.append(load("res://enemies/eye.tscn"))
	creatures.append(load("res://enemies/goblin.tscn"))
	creatures.append(load("res://enemies/witch.tscn"))
	
