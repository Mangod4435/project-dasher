extends Area2D

const SPEED = 10
signal on_note_touch_baseline
var inp_event: InputEvent

func _unhandled_input(event: InputEvent) -> void:
	inp_event = event

func _ready() -> void:
	on_note_touch_baseline.connect(_on_note_touch)
	area_entered.connect(_on_area_enter)

func _physics_process(_delta: float) -> void:
	if global_position.x < 0:
		queue_free()
	position.x -= SPEED

func _on_note_touch():
	print("Note touched baseline!!!!!!!!!!!!")

func _on_area_enter(area: Area2D):
	if area.is_in_group("BaseLine"):
		on_note_touch_baseline.emit()
