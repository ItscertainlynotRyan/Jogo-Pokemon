extends Node2D

@onready var timer = $Timer

# 👇 você vai arrastar o Spawn_Area aqui no editor

@onready var spawn_area: Area2D = $Spawn_Area

# comuns
var common_pokemons = [
	preload("res://zapdos.tscn"),
	preload("res://moltres.tscn"),
	preload("res://articuno.tscn"),
	preload("res://mewtwo.tscn")
]

# raro
var rare_pokemon = preload("res://mew.tscn")

func _ready():
	randomize()

func _on_timer_timeout():
	spawn_pokemon()


func spawn_pokemon():
	# limite de inimigos na tela
	if get_tree().get_nodes_in_group("enemies").size() > 25:
		return

	if spawn_area == null:
		print("ERRO: spawn_area não definido!")
		return

	var shape_node = spawn_area.get_node("CollisionShape2D")
	if shape_node == null:
		print("ERRO: CollisionShape2D não encontrado!")
		return

	var shape = shape_node.shape
	var extents = shape.extents
	var area_pos = spawn_area.global_position

	# chance de raro (10%)
	var pokemon_scene
	if randi_range(1, 10) == 1:
		pokemon_scene = rare_pokemon
	else:
		pokemon_scene = common_pokemons.pick_random()

	var pokemon = pokemon_scene.instantiate()

	# spawn dentro da área e sem sobreposição
	var safe_distance = 100  # distância mínima entre inimigos
	var tries = 0
	var pos: Vector2

	while true:
		pos = Vector2(
			randf_range(area_pos.x - extents.x, area_pos.x + extents.x),
			randf_range(area_pos.y - extents.y, area_pos.y + extents.y)
		)

		var overlap = false
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if pos.distance_to(enemy.position) < safe_distance:
				overlap = true
				break

		if not overlap:
			break

		tries += 1
		if tries > 50:  # evita loop infinito
			break

	pokemon.position = pos
	add_child(pokemon)
	pokemon.add_to_group("enemies")
