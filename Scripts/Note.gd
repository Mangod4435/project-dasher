extends Area2D

const SPEED = 10
signal on_note_touch_baseline
var _inp_event: InputEvent
var _BaseLine_x_pos: float

func _unhandled_input(event: InputEvent) -> void:
	_inp_event = event

func _ready() -> void:
	on_note_touch_baseline.connect(_on_note_touch)
	area_entered.connect(_on_area_enter)
	_BaseLine_x_pos = get_node("/root/GameScene/BaseLine").position.x

func _physics_process(_delta: float) -> void:
	if global_position.x < 0:
		queue_free()
	position.x -= SPEED

func _on_note_touch():
	if _inp_event is InputEventKey:
		var _pressed: bool = _inp_event.is_pressed() and _inp_event.keycode != KEY_ESCAPE
		var _released: bool = _inp_event.is_released()
		var _meta: String = get_meta("Type")
		if !_inp_event.is_echo() and _meta == "Tap" and _pressed:
			var offset = abs(global_position.x - _BaseLine_x_pos)
			var score = abs(100 - offset)
			ScoreManager.currentScore += score
			queue_free()
		elif (_pressed or _released) and _meta == "End":
			ScoreManager.currentScore += 100
			queue_free()
		elif _released and _meta == "Tail":
			ScoreManager.currentScore -= 100
			queue_free()

func _on_area_enter(area: Area2D):
	if area.is_in_group("BaseLine"):
		on_note_touch_baseline.emit()
