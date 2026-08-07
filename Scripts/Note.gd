extends Node2D

const SPEED = 7.5

func _physics_process(_delta: float) -> void:
	position.x -= SPEED 
