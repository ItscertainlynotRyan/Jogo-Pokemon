extends CharacterBody2D

var gravity = 900
var original_gravity = 900

var bounce = -60

var speed = 200
var original_speed = 200

var is_effect_active = false
var is_immune = false

var effect_time = 0
var current_effect = ""

var reverse_control = false

@onready var effect_label = get_parent().get_node("EffectLabel")

func _physics_process(delta):

	velocity.y += gravity * delta

	var direction = 0
	direction += Input.get_axis("ui_left", "ui_right")

	var accel = Input.get_accelerometer()
	direction += accel.x

	# 👇 CONFUSION
	if reverse_control:
		direction *= -1

	velocity.x = move_toward(velocity.x, direction * speed, 800 * delta)

	if is_on_floor():
		velocity.y *= bounce

	move_and_slide()

	# ------------------ TIMER ------------------
	if (is_effect_active or is_immune):
		effect_time -= delta

	# ------------------ UI ------------------
	if effect_label:
		if current_effect == "ice":
			effect_label.text = "🧊 Congelar: " + str(max(0, int(effect_time))) + "s"
		elif current_effect == "fire":
			effect_label.text = "🔥 Agilidade: " + str(max(0, int(effect_time))) + "s"
		elif current_effect == "Confusion":
			effect_label.text = "😵 Confusão: " + str(max(0, int(effect_time))) + "s"
		elif current_effect == "paralyzed":
			effect_label.text = "⚡ Paralisado: " + str(max(0, int(effect_time))) + "s"
		elif current_effect == "imunidade":
			effect_label.text = "🛡️ Imune: " + str(max(0, int(effect_time))) + "s"

	# ------------------ FINALIZA ------------------
	if effect_time <= 0:
		reset_all_effects()


# ------------------ APLICAR EFEITO ------------------
func apply_effect(effect_name):

	# 🛡️ IMUNIDADE (PRIORIDADE MÁXIMA)
	if effect_name == "imunidade":
		print("IMUNIDADE ATIVADA")

		# limpa efeitos atuais (sem mexer na imunidade ainda)
		speed = original_speed
		gravity = original_gravity
		reverse_control = false

		is_effect_active = false

		# ativa imunidade
		is_immune = true
		effect_time = 10
		current_effect = "imunidade"

		return

	# bloqueia se estiver imune
	if is_immune:
		print("EFEITO BLOQUEADO")
		return

	# bloqueia se já tiver efeito
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


# ------------------ RESET ------------------
func reset_all_effects():
	speed = original_speed
	gravity = original_gravity
	reverse_control = false

	is_effect_active = false
	is_immune = false
	current_effect = ""

	if effect_label:
		effect_label.text = ""
