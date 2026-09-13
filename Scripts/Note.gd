extends Area2D

const SPEED = 10
var _inp_event: InputEvent
var _BaseLine_x_pos: float
var _touching_baseline: bool = false

func _unhandled_input(event: InputEvent) -> void:
	_inp_event = event
	# Check judgement live on every input event instead of only on the single
	# physics frame the overlap began — otherwise a keypress has to land on
	# that exact frame or it's missed entirely.
	if _touching_baseline:
		_on_note_touch()

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
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
		_touching_baseline = true

func _on_area_exit(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = false
