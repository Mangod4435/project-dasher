extends Area2D

const SPEED = 10
signal on_note_touch_baseline

func _ready() -> void:
	area_entered.connect(_on_area_enter)
	pass
func _physics_process(_delta: float) -> void:
	if global_position.x < 0:
		queue_free()
	position.x -= SPEED 

func _on_area_enter(area: Area2D):
	if area.get_script().resource_name == "BaseLine.gd":
		on_note_touch_baseline.emit()
		pass
