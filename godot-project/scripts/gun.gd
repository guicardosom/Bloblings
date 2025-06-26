extends Area2D

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var target = enemies_in_range[0]
		look_at(target.global_position)
