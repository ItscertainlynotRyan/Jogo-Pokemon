extends Node2D

# ------------------ VARIÁVEIS ------------------
var score = 0
var is_effect_active = false
var effect_time = 0

var speed = 200
var original_speed = 200
var gravity = 400
var original_gravity = 400

# dificuldade
var game_time = 0
var difficulty_scale = 1.0

# escala de efeitos
var effect_multiplier = 1.0

# spawn
var spawn_timer = 0
var spawn_interval = 3.0

@export var pokemon_scenes: Array[PackedScene]

@onready var score_label = $Score
@onready var game_over_ui = $GameOverUI
@onready var game_over_text = $GameOverUI/Control/CenterContainer/TextureRect/VBoxContainer/GameOverText
@onready var effect_label = $EffectLabel
@onready var difficulty_label: Label = $DifficultyLabel
@onready var player = $Player

func _ready():
	randomize()

# ------------------ LOOP PRINCIPAL ------------------
func _process(delta):
	game_time += delta

	# 🔥 dificuldade progressiva contínua
	update_difficulty()

	# escala de efeitos (mantido)
	update_effect_scaling()

	# spawn
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_pokemon()
		spawn_timer = 0

# ------------------ DIFICULDADE ------------------
func update_difficulty():
	# escala com o tempo
	difficulty_scale = 1 + (game_time / 30.0)

	# spawn cada vez mais rápido
	spawn_interval = max(0.4, 3.0 - (game_time / 20.0))

	# mostra na tela
	difficulty_label.text = "Dificuldade: %.1f" % difficulty_scale

# ------------------ ESCALA DE EFEITOS ------------------
func update_effect_scaling():
	if game_time >= 120:
		effect_multiplier = 3.0
	elif game_time >= 60:
		effect_multiplier = 2.0
	else:
		effect_multiplier = 1.0

# ------------------ SPAWN ------------------
func spawn_pokemon():
	if pokemon_scenes.is_empty():
		return

	# 🔥 limite dinâmico de inimigos
	var max_enemies = 20 + int(game_time / 10)

	if get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return
	
	var scene = pokemon_scenes.pick_random()
	var pokemon = scene.instantiate()

	var pos: Vector2
	
	while true:
		pos = Vector2(
			randf_range(100, 1000),
			randf_range(100, 600)
		)
		
		if pos.distance_to(player.position) > 200:
			break

	pokemon.position = pos

	# aplica dificuldade nos pokémons
	if pokemon.has_method("set_difficulty"):
		pokemon.set_difficulty(difficulty_scale)

	add_child(pokemon)

# ------------------ EFEITOS ------------------
func apply_effect(effect_name):
	if is_effect_active:
		return
	
	is_effect_active = true
	
	effect_time = 5 * effect_multiplier
	
	print("🔥 Tempo do efeito:", effect_time)

	speed = original_speed
	gravity = original_gravity

	effect_label.text = effect_name

	var timer = Timer.new()
	timer.wait_time = effect_time
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(reset_effect)

func reset_effect():
	speed = original_speed
	gravity = original_gravity
	is_effect_active = false
	
	effect_label.text = ""

# ------------------ SCORE ------------------
func add_score():
	score += 1
	score_label.text = "Khangaskan: " + str(score)

# ------------------ GAME OVER ------------------
func game_over():
	get_tree().paused = true
	game_over_ui.visible = true
	game_over_text.text = "Game Over\nScore: " + str(score)

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_mew_body_entered(body: Node2D) -> void:
	pass
