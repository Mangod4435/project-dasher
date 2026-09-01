extends Area2D

var overlapping: Array[Area2D] = []
var holding_note: Node2D = null

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	if area.is_in_group("Notes"):
		overlapping.append(area)

func _on_area_exited(area: Area2D):
	if area.is_in_group("Notes"):
		overlapping.erase(area)

		# End collider passing through the baseline = hold finished, resolve it
		if area.name == "End" and holding_note == area.get_parent():
			_resolve_hold_release()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and overlapping.size() != 0:
		if !event.keycode == KEY_ESCAPE && !event.is_echo():
			var area = overlapping[0]
			var note = area.get_parent() if area.name == "Tap" else area.get_parent().get_parent()

			if event.is_pressed():
				if note.get_meta("Type") == "Tap":
					_resolve_tap(area, note)
				elif note.get_meta("Type") == "Hold" and area.name == "Head":
					holding_note = area.get_parent()  # the "Hold" node
					var offset = abs(area.global_position.x - position.x)
					note.set_meta("press_judgement", get_judgement(offset))

			elif event.is_released():
				if note.get_meta("Type") == "Hold" and area.get_parent() == holding_note:
					# released before End collider passed through = early release
					_resolve_hold_release(true)

func _resolve_tap(area: Area2D, note: Node2D):
	var offset = abs(area.global_position.x - position.x)
	var score = abs(50 - offset)
	ScoreManager.currentScore += score
	ScoreManager.show_judgement(get_judgement(offset))
	note.queue_free()
	overlapping.erase(area)

func _resolve_hold_release(early: bool = false):
	if holding_note == null:
		return
	var judgement = holding_note.get_meta("press_judgement", "miss")
	if early:
		judgement = "miss"
	ScoreManager.show_judgement(judgement)
	holding_note.get_parent().queue_free()  # frees the whole Note
	holding_note = null

func get_judgement(offset: float) -> String:
	if offset <= 15: return "perfect"
	elif offset <= 30: return "great"
	elif offset <= 50: return "good"
	else: return "miss"
