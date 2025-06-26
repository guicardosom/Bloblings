extends CharacterBody2D

@export var health = 3
@export var speed = 300 
@export var explosion_scene: PackedScene
@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	%Slime.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func take_damage() -> void:
	health -= 1
	%Slime.play_hurt()
	
	if health == 0:
		queue_free()
		
		var smoke = explosion_scene.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
