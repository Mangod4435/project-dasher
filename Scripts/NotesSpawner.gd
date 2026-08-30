extends Node2D

var this_chart = JSONReader.LoadJson("res://Charts/ChartTest.json")

func _ready() -> void:
	# pxPerBeat = 10 * 100 * 60 / BPM
	# pxPerBeat = v * tick * 60 / BPM
	var one_beat = 600 / this_chart.tempo
	var notes = this_chart.notes

	for note in notes: # for loop every note existed in th chart
		var templ: Node2D

		if note.end > 1:
			pass

		templ = preload("res://Scenes/Note.tscn").instantiate() as Node2D
		match int(note.species):
			0:
				if note.end == 0: # Tap Note
					free_other_child(templ, "Tap") # free everything except Hold node

					# Set the position of hold to be center
					var _hold = templ.get_node("Hold") as Node2D
					_hold.position = Vector2.ZERO

					templ.set_meta("Type", "Tap")# set meta
					
				else: # Hold Note
					free_other_child(templ, "Hold") # free everything except Hold node

					# Set the position of hold to be center
					var _tap = templ.get_node("Tap") as Node2D 
					_tap.position = Vector2.ZERO

					# set the tail size
					var _tail = templ.get_node("Hold/Tail") as Node2D
					_tail.scale.x = one_beat * note.end * 0.25
					_tail.position.x = 200 * _tail.scale.x 

					var _end = templ.get_node("Hold/End") as Node2D
					_end.position.x = 400 * _tail.scale.x

					templ.set_meta("Type", "Hold") # set meta

		var output_pos = Vector2(one_beat * note["beat"] * 100, 0) # matching y postion
		match int(note["y"]):
			0: output_pos.y = 360
			1: output_pos.y = 240
			2: output_pos.y = 480

		templ.position = output_pos # apply postion to templ
		add_child(templ) # add templ to the main tree

func free_other_child(parent: Node, except: String):
	for child in parent.get_children():
		if child.name != except:
			child.queue_free()