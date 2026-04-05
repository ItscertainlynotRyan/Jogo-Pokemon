extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")

# Quando o jogador encosta
func _on_body_entered(body):
	if body.is_class("CharacterBody2D"): 
		print("Mew coletado! Todos os inimigos eliminados!")
		body.apply_effect("mew")
		queue_free() # opcional: Mew desaparece após coletar

func _on_body_exited(body: Node2D) -> void:
	pass
