extends Node2D

func _ready() -> void:
	var this_chart = JSONReader.LoadJson("res://Charts/ChartTest.json")
	var posistions = this_chart.notes
	for note in posistions:
		var templ: Node2D
		match int(note.t):
			0:
				templ = preload("res://Scenes/Note.tscn").instantiate() as Node2D
		var output_pos = Vector2(note["x"] + position.x, 0)
		match int(note["y"]):
			0:
				output_pos.y = 360
			1:
				output_pos.y = 240
			2:
				output_pos.y = 480
		templ.position = output_pos
		add_child(templ)
