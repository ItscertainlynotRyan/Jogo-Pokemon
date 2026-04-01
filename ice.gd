extends Area2D

func _on_body_entered(body):
	if body.name == "Ball":
		print("Entrou no gelo")
		body.apply_effect("ice")
