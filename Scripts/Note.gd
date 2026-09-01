extends Node2D

const SPEED = 10

func _physics_process(_delta: float) -> void:
	if global_position.x < -50:
		queue_free()
	position.x -= SPEED 
