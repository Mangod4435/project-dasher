extends Node

var held_keys: int = 0
var current_keycode: Key

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.echo:
		if event.pressed:
			held_keys += 1
			current_keycode = event.keycode
		elif event.is_released():
			held_keys = max(0, held_keys - 1)
			current_keycode = KEY_NONE

func is_any_key_held() -> bool:
	return held_keys > 0

func get_curr_keycode() -> Key:
	return current_keycode
