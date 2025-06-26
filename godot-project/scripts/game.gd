extends Node2D

@export var blob_scene: PackedScene

func spawn_blob() -> void:
	var new_blob = blob_scene.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_blob.global_position = %PathFollow2D.global_position
	add_child(new_blob)

func _on_timer_timeout() -> void:
	spawn_blob()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true
