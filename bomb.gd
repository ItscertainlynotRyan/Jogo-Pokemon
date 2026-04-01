extends Area2D
# Define que este objeto é uma área de detecção.
# Area2D detecta quando outros corpos entram na área,
# mas não bloqueia movimento como um corpo físico.

func _on_body_entered(body):
# Esta função é chamada automaticamente quando algum corpo
# (por exemplo, a bola) entra na área da estrela.

	if body.name == "Ball":
		print("Tocou na bomba")
		# Verifica se o objeto que entrou na área é a bola.
		# Isso evita que outros objetos ativem a bomba.
		get_parent().game_over()
		
