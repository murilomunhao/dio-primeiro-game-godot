class_name Player
extends CharacterBody2D

#________________________________________________________________#
@export_category("Movement")
@export var speed: float = 3
#________________________________________________________________#
@export_category("Sword")
@export var sword_damage: int = 2
#________________________________________________________________#
@export_category("Rirual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 20
@export var ritual_scene: PackedScene 
#________________________________________________________________#
@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
#________________________________________________________________#
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_progress_bar: TextureProgressBar = $HealthProgressBar
@onready var attack_one_effect: AudioStreamPlayer = $AttackOneEffect
@onready var attack_two_effect: AudioStreamPlayer = $AttackTwoEffect
@onready var heal_effect: AudioStreamPlayer = $HealEffect



#________________________________________________________________#
var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 10.0
var damage_amount: int 


signal life_collected(regeneration_value: int)



func _ready():
	GameManager.player = self
	life_collected.connect(func(regeneration_value):
		if regeneration_value == 5:
			GameManager.life_core_counter += 1
		elif regeneration_value == 10:
			GameManager.life_precious_counter += 1
		)

func _process(delta:float) -> void:
	GameManager.player_position = position
	# Ler input
	read_input()
	# Processar ataque
	update_attack_cooldown(delta)
	attack()
	# Processar animação e rotação de sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
	# Processar dano
	update_hitbox_detection(delta)
	# Ritual
	update_ritual(delta)
	# Atualizar health bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
	if health_progress_bar.value < 99:
		$HealthProgressBar/BgRight/ProgreesRight.visible = false
	else:
		$HealthProgressBar/BgRight/ProgreesRight.visible = true

func _physics_process(delta: float) -> void:
	# Modificar velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity,0.15)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	# Atualiza temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func update_ritual(delta: float) -> void:
	# Atualizar temporixador
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	
	# Resetar temporizador
	ritual_cooldown = ritual_interval
	
	# Criar ritual
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)

func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	# Corrigir deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	# Atualiza se esta correndo
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
func play_run_idle_animation() -> void:
	# Chama a animação de corrida
	if not is_attacking:
		if health <= 0: return
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	# Inverte a direção da animação de acordo com o sentido da tecla precionada.
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func attack() -> void:
	if health <= 0: return
	# Attack 1
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")
		verify_is_attacking()
		sword_damage = 3
	# Attack 2
	elif Input.is_action_just_pressed("attackTwo"):
		animation_player.play("attackTwo")
		verify_is_attacking()
		sword_damage = 2
		
func verify_is_attacking() -> void:
	if is_attacking: return
	attack_cooldown = 0.45
	is_attacking = true
	
func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT 
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
			

func update_hitbox_detection(delta) -> void:
	# Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	# Frequencia (2x por segundo)
	hitbox_cooldown = 0.5
	
	# Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			if body.is_in_group("enemies_level_1"):
				damage_amount = 1
			elif body.is_in_group("enemies_level_2"):
				damage_amount = 2
			elif body.is_in_group("enemies_level_3"):
				damage_amount = 3
				
			damage(damage_amount)

func damage(amount: int) -> void:
	health -= amount
	# Piscar inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	# Precessar morte
	if health <= 0:
		die()
	print("Player recebeu dano de: ", amount, ". A vida total é de: ", health, "/", max_health)

func die() -> void:
	GameManager.end_game()
	animation_player.play("death")
	
func heal(amount: int) -> int:
	health += amount
	heal_effect.play()
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount, ". A vida total é de ",health, "/", max_health)
	return health
	
func effect_attack_one() -> void:
	attack_one_effect.play()
func effect_attack_two() -> void:
	attack_two_effect.play()
