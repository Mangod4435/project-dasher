extends Node2D

var this_chart = JSONReader.LoadJson("res://Charts/ChartTest.json")

# pxPerBeat = 10 * 100 * 60 / BPM

func _ready() -> void:
	var notes = this_chart.notes
	for note in notes:
		var templ: Node2D
		match int(note.species):
			0:
				templ = preload("res://Scenes/Note.tscn").instantiate() as Node2D
		var output_pos = Vector2(_get_baked_x_postion(note["beat"]), 0)
		match int(note["y"]):
			0:
				output_pos.y = 360
			1:
				output_pos.y = 240
			2:
				output_pos.y = 480
		templ.position = output_pos
		add_child(templ)
	pass

func  _get_baked_x_postion(beat: float) -> float:
	return beat * 60000 / this_chart["tempo"] + global_position.x + 1000
