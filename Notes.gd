extends Node2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta
