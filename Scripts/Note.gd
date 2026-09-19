extends Area2D

const SPEED = 10
const EARLY_LIMIT_PX = 120
var _BaseLine_x_pos: float
var _touching_baseline: bool = false

# signal
func _on_area_enter(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = true

func _on_area_exit(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = false

func _unhandled_input(event: InputEvent) -> void:
	if _touching_baseline:
		_on_note_touch(event)

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

# custom signal
func _on_note_touch(_event: InputEvent):
	if _event is InputEventKey:
		# variable
		var _pressed: bool = _event.is_pressed() and _event.keycode != KEY_ESCAPE
		var _released: bool = _event.is_released()
		var _meta: String = get_meta("Type")

		# Tap condition
		if !_event.is_echo() and _meta == "Tap" and _pressed:
			if get_parent().name == "Hold":
				get_parent().set_meta("active_keycode", _event.keycode)
			var offset = abs(global_position.x - _BaseLine_x_pos)
			var score = abs(100 - offset)
			ScoreManager.currentScore += score
			queue_free()

		# End condition
		elif (_pressed or _released) and _meta == "End":
			ScoreManager.currentScore += 100
			queue_free()

		# Tail condition
		elif _released and _meta == "Tail":
			var early_offset = global_position.x - _BaseLine_x_pos
			if early_offset > EARLY_LIMIT_PX: ScoreManager.currentScore -= 100 # too early
			else: ScoreManager.currentScore += 100 # just enough
			queue_free()
