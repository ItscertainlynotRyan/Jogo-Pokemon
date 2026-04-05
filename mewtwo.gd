extends Area2D

func _on_body_entered(body):
	if body.name == "Kangaskhan":
		print("foi atingido pelo Mewtwo")
		body.apply_effect("Confusion")
		add_to_group("enemies")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")
