extends Node2D

const SPEED = 7.5

func _physics_process(delta: float) -> void:
	position.x -= SPEED 
