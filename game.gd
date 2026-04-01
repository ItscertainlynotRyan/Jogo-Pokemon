extends Node2D

# ------------------ VARIÁVEIS ------------------
var score = 0
var is_effect_active = false
var effect_time = 0

var speed = 200
var original_speed = 200
var gravity = 400
var original_gravity = 400

@onready var score_label = $Score
@onready var game_over_ui = $GameOverUI
@onready var game_over_text = $GameOverUI/Control/CenterContainer/TextureRect/VBoxContainer/GameOverText
@onready var effect_label = $EffectLabel

func _ready():
	randomize()

# ------------------ EFEITOS ------------------
func apply_effect(effect_name):
	print("Aplicando efeito:", effect_name)

	if is_effect_active:
		print("Efeito já ativo, ignorando")
		return
	
	is_effect_active = true
	effect_time = 5

	# reset base
	speed = original_speed
	gravity = original_gravity

	match effect_name:
		"ice":
			speed *= 0.5
			gravity *= 0.5
			effect_label.text = "🧊 Gelo: 5s"
		"fire":
			speed *= 1.5
			gravity *= 1.3
			effect_label.text = "🔥 Fogo: 5s"

	# Cria temporizador
	var timer = Timer.new()
	timer.wait_time = effect_time
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(reset_effect)

# Função para resetar o efeito
func reset_effect():
	speed = original_speed
	gravity = original_gravity
	is_effect_active = false
	effect_label.text = ""
	print("Efeito finalizado")

# ------------------ SCORE ------------------
func add_score():
	print("Adicionando score...")
	score += 1
	score_label.text = "Khangaskan: " + str(score)

# ------------------ GAME OVER ------------------
func game_over():
	print("Chamada da função Game Over")
	get_tree().paused = true
	game_over_ui.visible = true
	game_over_text.text = "Game Over\nScore: " + str(score)

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
