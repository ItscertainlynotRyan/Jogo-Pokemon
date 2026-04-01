extends Area2D
# Define que este objeto é uma área de detecção.
# Area2D detecta quando outros corpos entram na área,
# mas não bloqueia movimento como um corpo físico.

func _on_body_entered(body):
# Esta função é chamada automaticamente quando algum corpo
# (por exemplo, a bola) entra na área da estrela.

	if body.name == "Ball":
		print("Tocou no Baby Khangaskan")
		# Verifica se o objeto que entrou na área é a bola.
		# Isso evita que outros objetos ativem a estrela.
		get_parent().add_score()
		reposition_star()
		# Chama a função que vai mover a estrela
		# para uma nova posição na tela.

func reposition_star():
# Função responsável por gerar uma nova posição aleatória
# para a estrela aparecer em outro lugar.

	var x = randf_range(50, 750)
	# Gera um número aleatório entre 50 e 750.
	# Esse será o novo valor da posição horizontal (X).

	var y = randf_range(50, 400)
	# Gera um número aleatório entre 50 e 400.
	# Esse será o novo valor da posição vertical (Y).

	position = Vector2(x, y)
	# Define a nova posição da estrela usando os valores aleatórios.
	# Vector2 representa uma posição 2D (X,Y).
