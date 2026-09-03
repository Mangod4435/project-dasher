extends Area2D

var overlapping: Array[Area2D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	if area.is_in_group("Notes"):
		overlapping.append(area)

func _on_area_exited(area: Area2D):
	if area.is_in_group("Notes"):
		overlapping.erase(area)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and overlapping.size() != 0:
		if !event.keycode == KEY_ESCAPE and !event.is_echo() and overlapping[0].get_meta("Type") == "Tap": # tap note and head
			var offset = abs(overlapping[0].global_position.x - position.x)
			var score = abs(50 - offset)
			overlapping[0].queue_free()
			overlapping.remove_at(0)
			ScoreManager.currentScore += score
		elif event.is_released() and overlapping[0].get_meta("Type") == "Tail":
			var offset = overlapping[0].global_position.x - position.x * 2
			if offset > -200 * overlapping[0].scale.x:
				overlapping[0].queue_free()
				ScoreManager.currentScore -= 50
		elif (event.is_pressed() and event.is_echo()) or event.is_released() and overlapping[0].get_meta("Type") == "End":
			var _offset = overlapping[0].global_position.x - position.x
			
