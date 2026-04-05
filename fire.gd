extends Area2D

func _on_body_entered(body):
	if body.name == "Kangaskhan":
		print("Foi atingido pelo Moltres")
		body.apply_effect("fire")
		add_to_group("enemies")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")

func _process(delta):
	var screen_size = get_viewport_rect().size
	var margin = 20

	position.x = clamp(position.x, margin, screen_size.x - margin)
	position.y = clamp(position.y, margin, screen_size.y - margin)
