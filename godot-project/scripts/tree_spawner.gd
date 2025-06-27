extends Node2D

@export var tree_scene: PackedScene
@export var player: Node2D
@export var chunk_size: int = 512
@export var trees_per_chunk: int = 5
@export var render_distance: int = 2

var active_chunks: Dictionary = {}

func _process(_delta):
	if player:
		update_chunks_around_player()

func get_chunk_coords(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(pos.x / chunk_size),
		floor(pos.y / chunk_size)
	)	

func update_chunks_around_player():
	var player_chunk = get_chunk_coords(player.global_position)

	# Spawn chunks around the player
	for x in range(player_chunk.x - render_distance, player_chunk.x + render_distance + 1):
		for y in range(player_chunk.y - render_distance, player_chunk.y + render_distance + 1):
			var chunk_coords = Vector2i(x, y)
			if not active_chunks.has(chunk_coords):
				spawn_chunk(chunk_coords)

	# Despawn chunks that are too far
	var chunks_to_remove = []
	for chunk_coords in active_chunks.keys():
		if chunk_coords.distance_to(player_chunk) > render_distance + 1:
			active_chunks[chunk_coords].queue_free()
			chunks_to_remove.append(chunk_coords)

	for coords in chunks_to_remove:
		active_chunks.erase(coords)

func spawn_chunk(chunk_coords: Vector2i):
	var chunk = Node2D.new()
	add_child(chunk)
	active_chunks[chunk_coords] = chunk

	var chunk_origin = Vector2(chunk_coords.x * chunk_size, chunk_coords.y * chunk_size)

	var rng = RandomNumberGenerator.new()
	rng.seed = hash(chunk_coords)

	for i in trees_per_chunk:
		var tree = tree_scene.instantiate()
		var local_pos = Vector2(
			rng.randf_range(0, chunk_size),
			rng.randf_range(0, chunk_size)
		)
		tree.position = chunk_origin + local_pos
		chunk.add_child(tree)
