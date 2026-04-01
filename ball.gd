extends CharacterBody2D

var gravity = 900
var original_gravity = 900

var bounce = -60

var speed = 200
var original_speed = 200

var is_effect_active = false
var effect_time = 0
var current_effect = ""

# 🔥 pega o label automaticamente (ajuste o nome se precisar)
@onready var effect_label = get_parent().get_node("EffectLabel")

func _physics_process(delta):

	velocity.y += gravity * delta

	var direction = 0
	direction += Input.get_axis("ui_left", "ui_right")

	var accel = Input.get_accelerometer()
	direction += accel.x

	velocity.x = move_toward(velocity.x, direction * speed, 800 * delta)

	if is_on_floor():
		velocity.y *= bounce

	move_and_slide()

	# atualiza texto com proteção
	if is_effect_active and effect_label:
		effect_time -= delta
		
		if current_effect == "ice":
			effect_label.text = "🧊 Gelo: " + str(max(0, int(effect_time))) + "s"
		elif current_effect == "fire":
			effect_label.text = "🔥 Fogo: " + str(max(0, int(effect_time))) + "s"


func apply_effect(effect_name):

	if is_effect_active:
		return
	
	is_effect_active = true
	effect_time = 5
	current_effect = effect_name

	speed = original_speed
	gravity = original_gravity

	match effect_name:
		"ice":
			speed *= 0.5
			gravity *= 0.5
		
		"fire":
			speed *= 2.0
			gravity *= 1.5

	await get_tree().create_timer(5.0).timeout

	speed = original_speed
	gravity = original_gravity

	is_effect_active = false
	current_effect = ""

	if effect_label:
		effect_label.text = ""
