extends Node2D

var game_time = 0.0
var mewtwo_spawned = false
var mew_spawned = false
var start_spawn_done = false
var difficulty_scale = 1.0

@export var zapdos_scene: PackedScene
@export var moltres_scene: PackedScene
@export var articuno_scene: PackedScene
@export var mewtwo_scene: PackedScene
@export var mew_scene: PackedScene

# Referência ao player (vamos pegar de forma mais segura)
var player: Node2D = null

func _ready():
	randomize()
	
	# Tenta pegar o player de forma segura
	player = get_parent().get_node_or_null("Player")
	
	# Se não encontrar, tenta pelo grupo (recomendado)
	if player == null:
		player = get_tree().get_first_node_in_group("player")

func _process(delta):
	game_time += delta
	handle_spawns()

# ------------------ SPAWNS ------------------
func handle_spawns():
	# Spawn inicial dos 3 lendários
	if not start_spawn_done:
		spawn_pokemon(zapdos_scene)
		spawn_pokemon(moltres_scene)
		spawn_pokemon(articuno_scene)
		start_spawn_done = true

	# Mewtwo (a partir de 10 segundos)
	if game_time > 10 and not mewtwo_spawned:
		var amount = randi_range(2, 3)
		for i in amount:
			spawn_pokemon(mewtwo_scene)
		mewtwo_spawned = true

	# Mew (a partir de 30 segundos)
	if game_time > 30 and not mew_spawned:
		spawn_pokemon(mew_scene)
		mew_spawned = true

# ------------------ SPAWN ------------------
func spawn_pokemon(scene: PackedScene):
	if scene == null:
		return
	
	# Verifica se o player existe
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			push_warning("Spawner: Player não encontrado! Spawn cancelado.")
			return
	
	var pokemon = scene.instantiate()
	var pos: Vector2
	var attempts = 0
	var max_attempts = 50  # Evita travar o jogo
	
	while attempts < max_attempts:
		pos = Vector2(
			randf_range(100, 1000),
			randf_range(100, 600)
		)
		
		# Só aceita posição se estiver longe do player
		if pos.distance_to(player.position) > 200:
			break
			
		attempts += 1
	
	# Se não encontrou posição boa após muitas tentativas
	if attempts >= max_attempts:
		print("Aviso: Não foi possível encontrar posição válida para spawn.")
		pos = Vector2(randf_range(100, 1000), randf_range(100, 600))  # posição aleatória mesmo assim
	
	pokemon.position = pos
	
	# Aplica dificuldade
	if pokemon.has_method("set_difficulty"):
		pokemon.set_difficulty(difficulty_scale)
	
	add_child(pokemon)
