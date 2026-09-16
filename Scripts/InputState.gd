extends Node

var held_keys: int = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.echo:
		if event.pressed:
			held_keys += 1
		elif event.is_released():
			held_keys = max(0, held_keys - 1)
	elif event is InputEventScreenTouch:
		if event.pressed:
			held_keys += 1
		else:
			held_keys = max(0, held_keys - 1)

func is_any_key_held() -> bool:
	return held_keys > 0
