extends Node2D

func _process(_delta: float) -> void:
    if get_children()[0].name == "Hold" and get_children()[0].get_child_count() == 0:
        self.queue_free()
    elif get_child_count() == 0:
        self.queue_free()