extends CharacterBody2D

var gravity = 900
var original_gravity = 900

var bounce = -60
var speed = 200
var original_speed = 200

var is_effect_active = false
var effect_time = 0
var current_effect = ""

var reverse_control = false

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

	# ------------------ TIMER ------------------
	if is_effect_active:
		effect_time -= delta

	# ------------------ UI ------------------
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

	# ------------------ FINALIZA ------------------
	if effect_time <= 0:
		reset_all_effects()


# ------------------ APLICAR EFEITO ------------------
func apply_effect(effect_name):
	# Se for Mew, ignora tudo
	if effect_name == "mew":
		reset_all_effects()
		clear_enemies()
		is_effect_active = true
		current_effect = "mew"
		effect_time = 5
		return

	# efeitos normais
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


# ------------------ LIMPAR INIMIGOS ------------------
func clear_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()


# ------------------ RESET ------------------
func reset_all_effects():
	speed = original_speed
	gravity = original_gravity
	reverse_control = false

	is_effect_active = false
	current_effect = ""

	if effect_label:
		effect_label.text = ""


# ------------------ PEGAR MEW ------------------
func _on_mew_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		apply_effect("mew")
		print("Mew coletado! Todos os inimigos eliminados!")
