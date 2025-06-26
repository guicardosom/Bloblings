extends CharacterBody2D

signal health_depleted

@export var health = 100.0
@export var speed = 600
const DAMAGE_RATE = 5.0

func _process(delta: float) -> void:
	if velocity.length() > 0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	var overlapping_blobs = %HurtBox.get_overlapping_bodies()
	if overlapping_blobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_blobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()
