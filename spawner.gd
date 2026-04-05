extends Node2D

@onready var timer = $Timer

# 👇 você vai arrastar o Spawn_Area aqui no editor
@export var spawn_area: Node2D

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
	# limite na tela
	if get_child_count() > 15:
		return

	# segurança (evita erro)
	if spawn_area == null:
		print("ERRO: Spawn_Area não foi definido!")
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

	# spawn dentro da área
	var x = randf_range(area_pos.x - extents.x, area_pos.x + extents.x)
	var y = randf_range(area_pos.y - extents.y, area_pos.y + extents.y)

	pokemon.position = Vector2(x, y)

	add_child(pokemon)
