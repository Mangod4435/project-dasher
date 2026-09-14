extends Area2D

const SPEED = 10
const HOLD_EARLY_TOLERANCE_MS = 120
var _BaseLine_x_pos: float
var _touching_baseline: bool = false

func _unhandled_input(event: InputEvent) -> void:
	# Check judgement live on every input event instead of only on the single
	# physics frame the overlap began — otherwise a keypress has to land on
	# that exact frame or it's missed entirely.
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

func _on_note_touch(_event: InputEvent):
	if _event is InputEventKey:
		var _pressed: bool = _event.is_pressed() and _event.keycode != KEY_ESCAPE
		var _released: bool = _event.is_released()
		var _meta: String = get_meta("Type")
		if !_event.is_echo() and _meta == "Tap" and _pressed:
			# Head (the tap that kicks off a hold) lives under a "Hold" parent —
			# remember which key started the hold so an unrelated key release
			# later can't be mistaken for releasing this hold.
			if get_parent().name == "Hold":
				get_parent().set_meta("active_keycode", _event.keycode)
			var offset = abs(global_position.x - _BaseLine_x_pos)
			var score = abs(100 - offset)
			ScoreManager.currentScore += score
			queue_free()
		elif (_pressed or _released) and _meta == "End":
			ScoreManager.currentScore += 100
			queue_free()
		elif _released and _meta == "Tail":
			# Only the key that actually started the hold can end it — any other
			# key's release event should be ignored, not scored as an early let-go.
			var held_keycode: int = get_parent().get_meta("active_keycode", -1)
			if _event.keycode != held_keycode:
				return
			# Tail's anchor sits at the same x as the hold's End tip, so this
			# node's own global_position tells us how far off the release was.
			# Positive offset = tip hasn't reached the baseline yet (early).
			# Negative/zero offset = tip already passed the baseline (late) —
			# that's fine, only early releases get penalized.
			var pixels_per_ms = (SPEED * Engine.physics_ticks_per_second) / 1000.0
			var early_tolerance_px = HOLD_EARLY_TOLERANCE_MS * pixels_per_ms
			var early_offset = global_position.x - _BaseLine_x_pos
			if early_offset > early_tolerance_px:
				ScoreManager.currentScore -= 100
			else:
				ScoreManager.currentScore += 100
			queue_free()

func _on_area_enter(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = true

func _on_area_exit(area: Area2D):
	if area.is_in_group("BaseLine"):
		_touching_baseline = false
