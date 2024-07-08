extends Node

@export var mob_spawner: MobSpawner
@export var default_spawn_rate: float = 60.0
@export var mob_level_1_spawn_rate: float = 120.0
@export var mob_level_2_spawn_rate: float = 30.0
@export var mob_level_3_spawn_rate: float = 6.0
@export var spawn_rate_per_minute: float = 30.0
@export var wave_duration: float = 20
@export var break_intensity: float = 0.5

var time: float = 0.0
func _process(delta: float) -> void:
	if GameManager.is_game_over: return
	time += delta
	# Dificuldade linear
	var spawn_rate_mob_level_1 = mob_level_1_spawn_rate + spawn_rate_per_minute * (time / 60.0)
	var spawn_rate_mob_level_2 = mob_level_2_spawn_rate + spawn_rate_per_minute * (time / 60.0)
	var spawn_rate_mob_level_3 = mob_level_3_spawn_rate + spawn_rate_per_minute * (time / 60.0)
	
	# Sistema de ondas
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave,-1.0, 1.0, break_intensity, 1)
	spawn_rate_mob_level_1 *= wave_factor
	spawn_rate_mob_level_2 *= wave_factor
	spawn_rate_mob_level_3 *= wave_factor
	
	# Aplica dificuldade
	mob_spawner.mobs_level_1 = spawn_rate_mob_level_1
	mob_spawner.mobs_level_2 = spawn_rate_mob_level_2
	mob_spawner.mobs_level_3 = spawn_rate_mob_level_3
	
