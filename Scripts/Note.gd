extends Node2D

const SPEED = 7.5

func _physics_process(_delta: float) -> void:
	position.x -= SPEED

func _input(event: InputEvent) -> void:
	if event is InputEventKey and BaseLine.overlapping.size() != 0 and event.is_pressed():
		if !event.is_echo() and event.keycode != KEY_ESCAPE and self.get_meta("Type") == 0:
			var baseline = get_node("/root/GameScene/BaseLine")
			var score: float
			score = abs(50 - abs(baseline.position.x - global_position.x))
			ScoreManager.currentScore += round(score)
			print("hit")
