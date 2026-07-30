extends Area2D

func area_entered(area: Area2D):
	if area.is_in_group("Notes"):
		print("Notes collided")
		pass
	pass
