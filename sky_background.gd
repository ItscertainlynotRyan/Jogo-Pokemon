extends TextureRect

@export var morning : Texture2D
@export var afternoon : Texture2D
@export var golden : Texture2D
@export var sunset : Texture2D
@export var night_early : Texture2D
@export var night_deep : Texture2D

@export var cycle_duration := 60.0   # Tempo total do ciclo (em segundos)

var elapsed_time := 0.0

func _ready():
	# Faz o TextureRect preencher a tela inteira
	size = get_viewport_rect().size
	stretch_mode = TextureRect.STRETCH_SCALE
	
	# Define a textura inicial
	texture = morning if morning else texture

func _process(delta: float):
	elapsed_time += delta
	
	var progress = fmod(elapsed_time, cycle_duration) / cycle_duration

	if progress < 0.1667:
		texture = morning
	elif progress < 0.3333:
		texture = afternoon
	elif progress < 0.5:
		texture = golden
	elif progress < 0.6667:
		texture = sunset
	elif progress < 0.8333:
		texture = night_early
	else:
		texture = night_deep
