extends Area2D

const SPEED = 10
const EARLY_LIMIT_PX = 120
const BASELINE_POS = 250.0
var _touching_baseline: bool = false

# signal
func _on_area_enter(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = true

func _on_area_exit(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = false

func _input(event: InputEvent) -> void:
	if _touching_baseline:
		_on_note_touch(event)

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)

func _physics_process(_delta: float) -> void:
	if global_position.x < 0:
		if !self.get_meta("is_hit"):
			ScoreManager.currentScore -= 200
		queue_free()
	position.x -= SPEED
	if _touching_baseline and get_meta("Type") == "End" and InputState.is_any_key_held():
		ScoreManager.currentScore += 200
		set_meta("is_hit", true)
		queue_free()

# custom signal
func _on_note_touch(_event: InputEvent):
	if _event is InputEventKey:
		# variable
		var _pressed: bool = _event.is_pressed() and _event.keycode != KEY_ESCAPE
		var _released: bool = _event.is_released()
		var _meta: String = get_meta("Type")

		# Tap condition
		if _pressed and !_event.is_echo() and _meta == "Tap":
			if get_parent().name == "Hold":
				get_parent().set_meta("active_keycode", _event.keycode)
			var offset = abs(global_position.x - BASELINE_POS)
			var score = abs(200 - offset)
			ScoreManager.currentScore += score
			queue_free()

		# Tail condition
		elif _released and _meta == "Tail":
			if InputState.is_any_key_held():
				return
			var early_offset = global_position.x - BASELINE_POS
			if early_offset > EARLY_LIMIT_PX: ScoreManager.currentScore -= 200 # too early
			else: ScoreManager.currentScore += 200 # just enough
			queue_free()
		
		# set metadata
		set_meta("is_hit", true)
