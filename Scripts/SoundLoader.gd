extends AudioStreamPlayer

var this_chart = load("res://Charts/ChartTest.json").data
@export var isEnable: bool

func _ready() -> void:
	if isEnable:
		self.stream = load(this_chart["music"])
		await get_tree().create_timer(this_chart["delay"]).timeout
		play()
