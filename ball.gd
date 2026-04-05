extends CharacterBody2D

# --- Movimento e físicas ---
var gravity = 900
var original_gravity = 900
var bounce = -60
var speed = 200
var original_speed = 200
var reverse_control = false

# --- Efeitos ---
var is_effect_active = false
var effect_time = 0
var current_effect = ""

# --- UI ---
@onready var effect_label = get_parent().get_node("EffectLabel")

func _physics_process(delta):
	velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	direction += Input.get_accelerometer().x

	if reverse_control:
		direction *= -1

	velocity.x = move_toward(velocity.x, direction * speed, 800 * delta)

	if is_on_floor():
		velocity.y *= bounce

	move_and_slide()

	# Timer dos efeitos
	if is_effect_active:
		effect_time -= delta

	# Atualiza UI
	if effect_label:
		match current_effect:
			"ice":
				effect_label.text = "🧊 Congelar: " + str(max(0, int(effect_time))) + "s"
			"fire":
				effect_label.text = "🔥 Agilidade: " + str(max(0, int(effect_time))) + "s"
			"Confusion":
				effect_label.text = "😵 Confusão: " + str(max(0, int(effect_time))) + "s"
			"paralyzed":
				effect_label.text = "⚡ Paralisado: " + str(max(0, int(effect_time))) + "s"
			"mew":
				effect_label.text = "✨ LIMPEZA TOTAL!"

	if effect_time <= 0:
		reset_all_effects()


# --- Aplicar efeito ---
func apply_effect(effect_name):
	# Mew é supremo: sempre zera outros efeitos
	if effect_name == "mew":
		reset_all_effects()
		clear_enemies()
		is_effect_active = true
		current_effect = "mew"
		effect_time = 5
		return

	# Efeitos normais só se não houver outro ativo
	if is_effect_active:
		return

	is_effect_active = true
	effect_time = 5
	current_effect = effect_name

	speed = original_speed
	gravity = original_gravity
	reverse_control = false

	match effect_name:
		"ice":
			speed *= 0.5
			gravity *= 0.5
		"fire":
			speed *= 2.0
			gravity *= 1.5
		"Confusion":
			speed *= 1.2
			gravity *= 1.5
			if randi() % 2 == 0:
				reverse_control = true
		"paralyzed":
			speed = 0.0
			gravity = 0.0


# --- Limpar inimigos ---
func clear_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()


# --- Reset de efeitos ---
func reset_all_effects():
	speed = original_speed
	gravity = original_gravity
	reverse_control = false

	is_effect_active = false
	current_effect = ""

	if effect_label:
		effect_label.text = ""
