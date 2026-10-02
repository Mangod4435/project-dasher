extends AudioStreamPlayer

@onready var this_chart = get_node("/root/GameScene/LevelLoader").this_chart
@export var isEnable: bool

func _ready() -> void:
	self.stream = load(this_chart.music)
	if load(this_chart.music) == null:
		print("No existing music you talking about")
	if this_chart.get('delay', 0) > 0:
		await get_tree().create_timer(this_chart.get('delay')).timeout
	if isEnable: play()
	print("sound played")
