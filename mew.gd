extends Area2D

func _on_body_entered(body):
	if body.name == "Kangaskhan":
		print("foi salvo por Mew")
		body.apply_effect("clear")
		

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")
