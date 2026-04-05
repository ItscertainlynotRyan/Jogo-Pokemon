extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("fly")
	add_to_group("enemies")
	
func _on_body_entered(body):
	if body.has_method("apply_effect"):
		print("Foi atingido pelo Articuno")
		body.apply_effect("ice")
