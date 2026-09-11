extends Area2D

const SPEED = 10
signal on_note_touch_baseline
var inp_event: InputEvent
var BaseLine_x_pos: float

func _unhandled_input(event: InputEvent) -> void:
	inp_event = event

func _ready() -> void:
	on_note_touch_baseline.connect(_on_note_touch)
	area_entered.connect(_on_area_enter)
	BaseLine_x_pos = get_node("/root/GameScene/BaseLine").position.x

func _physics_process(_delta: float) -> void:
	if global_position.x < 0:
		queue_free()
	position.x -= SPEED

func _on_note_touch():
		if inp_event is InputEventKey and inp_event.keycode != KEY_ESCAPE:
			if !inp_event.is_echo() and get_meta("Type") == "Tap":
				var offset = abs(global_position.x - BaseLine_x_pos)
				var score = abs(100 - offset)
				queue_free()
				ScoreManager.currentScore += score
			elif inp_event.is_released() and get_meta("Type") == "Tail":
				var offset = global_position.x - BaseLine_x_pos * 2
				if offset > -200 * scale.x:
					queue_free()
					ScoreManager.currentScore -= 100
			elif (inp_event.is_pressed() or inp_event.is_released()) and get_meta("Type") == "End":
				ScoreManager.currentScore += 100

func _on_area_enter(area: Area2D):
	if area.is_in_group("BaseLine"):
		on_note_touch_baseline.emit()
