
extends Node2D
@export_category("Heals default")
@export var heal_per_minutes: float = 60.0
#________________________________________________________________#
@export_category("Heal by levels ")
@export var heal_level_1: float = 30.0
@export var heal_level_2: float = 12
#________________________________________________________________#
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var heals: Array[PackedScene] = []
var cooldown: float = 0.0
#________________________________________________________________#

func _ready():
	load_heals()
	
func _process(delta: float):
	if GameManager.is_game_over: return
	# Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Instanciar uma criatura aleatura
	var index = randi_range(0, heals.size() -1 )
	var heals_scene = heals[index]
	var heal = heals_scene.instantiate()
	heal.global_position = get_point()
	get_parent().add_child(heal)
	
# Verificar o nível do inimigo e definir o intervalo
	var interval = get_interval(heal)
	cooldown = interval
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position

func get_interval(heal: Node2D) -> float:
	if heal.is_in_group("heals_level_1"):
		if heal_level_1 <= 0:
			heal_level_1 = 1
		print("Nivel 1 heals instanciada. Intervalo:", 60.0 / heal_level_1)
		return 60.0 / heal_level_1 
	elif heal.is_in_group("heals_level_2"):
		if heal_level_2 <= 0:
			heal_level_2 = 1
		print("Nivel 2 heal instanciada. Intervalo:", 60.0 / heal_level_2)
		return 60.0 / heal_level_2 
	return 60.0 / heal_per_minutes # Valor padrão caso não esteja em nenhum grupo específico
	
func load_heals() -> void:
	heals.append(load("res://misc/core.tscn"))
	heals.append(load("res://misc/precious.tscn"))
	
