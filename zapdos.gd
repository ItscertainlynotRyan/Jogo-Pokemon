extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")   # ou o nome da sua animação

# Mude para este nome exato:
func _on_zapdos_body_entered(body: Node2D) -> void:
	if body.name == "Kangaskhan" or body.is_in_group("player"):   # melhor usar grupo
		print("Foi atingido pelo Zapdos")   # ← mude o texto depois
		body.apply_effect("paralyzed")
