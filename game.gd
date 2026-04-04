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

# spawn
var spawn_timer = 0
var spawn_interval = 3.0

@export var pokemon_scenes: Array[PackedScene]

@onready var score_label = $Score
@onready var game_over_ui = $GameOverUI
@onready var game_over_text = $GameOverUI/Control/CenterContainer/TextureRect/VBoxContainer/GameOverText
@onready var effect_label = $EffectLabel
@onready var player = $Player # 👈 importante

func _ready():
	randomize()

# ------------------ LOOP PRINCIPAL ------------------
func _process(delta):
	game_time += delta

	# aumenta dificuldade a cada 10s
	if int(game_time) % 10 == 0:
		increase_difficulty()

	# controle de spawn
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_pokemon()
		spawn_timer = 0

# ------------------ DIFICULDADE ------------------
func increase_difficulty():
	difficulty_scale += 0.1
	spawn_interval = max(0.8, spawn_interval - 0.2)

	print("Dificuldade:", difficulty_scale)

# ------------------ SPAWN ------------------
func spawn_pokemon():
	if pokemon_scenes.is_empty():
		return
	
	var scene = pokemon_scenes.pick_random()
	var pokemon = scene.instantiate()

	# posição longe do player
	var pos: Vector2
	
	while true:
		pos = Vector2(
			randf_range(100, 1000),
			randf_range(100, 600)
		)
		
		if pos.distance_to(player.position) > 200:
			break

	pokemon.position = pos

	# aplica dificuldade no pokemon
	if pokemon.has_method("set_difficulty"):
		pokemon.set_difficulty(difficulty_scale)

	add_child(pokemon)

# ------------------ EFEITOS ------------------
func apply_effect(effect_name):
	if is_effect_active:
		return
	
	is_effect_active = true
	effect_time = 5

	speed = original_speed
	gravity = original_gravity


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
	pass # Replace with function body.
