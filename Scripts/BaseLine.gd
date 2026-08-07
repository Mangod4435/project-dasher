extends Area2D
class_name BaseLine
static var overlapping: Array[Area2D] = []:
	get:
		return overlapping
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D): 
	if area.is_in_group("Notes"): overlapping.append(area)

func _on_area_exited(area: Area2D):
	if area.is_in_group("Notes"): overlapping.erase(area)
