extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")
	
func _on_body_entered(body):
	if body.name == "Kangaskhan":
		print("Foi atingido pelo Articuno")
		body.apply_effect("ice")
