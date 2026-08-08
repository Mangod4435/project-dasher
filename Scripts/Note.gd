extends Node2D

const SPEED = 10

func _physics_process(_delta: float) -> void:
	position.x -= SPEED 
