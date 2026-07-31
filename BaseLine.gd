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
	if event is InputEventKey:
		if event.pressed and !event.keycode == KEY_ESCAPE and overlapping.count(1) != 0:
			var _offset = overlapping[0].position - self.position
			overlapping[0].queue_free()
			overlapping.remove_at(0)
