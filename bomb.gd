extends Area2D

@export var respawn_time := 30.0

func _on_body_entered(body):
	if body.name == "Kangaskhan":
		print("Kangaskhan foi capturado")

		get_parent().game_over()

		# esconde a bomba
		hide()
		set_deferred("monitoring", false)

		respawn()

# ------------------ RESPAWN ------------------
func respawn():
	await get_tree().create_timer(respawn_time).timeout

	# nova posição aleatória
	position = Vector2(
		randf_range(100, 1000),
		randf_range(100, 600)
	)

	# reaparece
	show()
	set_deferred("monitoring", true)

	print("Rocket ball respawnou!")
