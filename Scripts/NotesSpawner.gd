extends Node2D

var this_chart = JSONReader.LoadJson("res://Charts/ChartTest.json")
var one_beat = 600 / this_chart.tempo

func _ready() -> void:
	var notes = this_chart.notes
	var note_id: int = 0
	for note in notes:
		var templ := preload("res://Scenes/Note.tscn").instantiate() as Node2D
		match int(note.species):
			0:
				if note.end == 0:
					_setup_tap(templ, note_id)
				else:
					_setup_hold(templ, note.end, note_id)
		note_id += 1
		var output_pos = Vector2(one_beat * note["beat"] * 100, 0)
		match int(note["y"]):
			0: output_pos.y = 360
			1: output_pos.y = 240
			2: output_pos.y = 480
		templ.position = output_pos
		add_child(templ)

func _setup_tap(templ: Node2D, id: int) -> void:
	templ.name = "Note %s" % id
	free_other_child(templ, "Tap")
	var _tap = templ.get_node("Tap") as Node2D
	_tap.position = Vector2.ZERO

func _setup_hold(templ: Node2D, end_beats: float, id: int) -> void:
	templ.name = "Note Hold %s" % id
	free_other_child(templ, "Hold")
	var _hold = templ.get_node("Hold") as Node2D
	_hold.position = Vector2.ZERO

	var _tail_are = _hold.get_node("Tail") as Node2D
	var _tail_spr = _tail_are.get_node("Tail") as Node2D
	var _tail_col = _tail_are.get_node("TailCollision") as CollisionShape2D
	var _end = _hold.get_node("End") as Node2D

	var length_px = one_beat * end_beats * 100  # match the same beat->pixel scale used for output_pos

	_tail_are.position.x = 0 # Tail node itself stays put; sprite/collision scale from here
	_tail_col.position.x = 0
	_tail_spr.position.x = length_px / 2 # sprite pivots at its own center, so shift it half its length
	_tail_spr.scale.x = length_px / 400 # base texture width is 400px
	_tail_col.shape.b.x = length_px # collision segment spans 0 -> length_px directly
	_end.position.x = length_px # End marker sits exactly at the tail's tip

# private helpers
func free_other_child(parent: Node, except: String):
	for child in parent.get_children():
		if child.name != except:
			child.queue_free()
