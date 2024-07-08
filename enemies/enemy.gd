class_name Enemy
extends Node2D

@export var death_prefab: PackedScene

@onready var damage_digit_marker = $DamageDigitMarker
@onready var enemy_health = self

var damage_digit_prefab: PackedScene
var health: int 




func _ready():
	
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")
	
	if enemy_health.is_in_group("enemies_level_1"):
		health = 2
	elif enemy_health.is_in_group("enemies_level_2"):
		health = 5
	elif  enemy_health.is_in_group("enemies_level_3"):
		health = 10
	else:
		health = 1
		
func damage(amount: int) -> void:
	health -= amount
	# Piscar inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	print("Inimigo recebeu dano de ", amount, ". A vida é ", health)
	
	# Criar DamageDigit
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position 
	else: 
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
	# Precessar morte
	if health <= 0:
		die()

func die() -> void:
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	GameManager.kill_enemies_counter += 1
	queue_free()
