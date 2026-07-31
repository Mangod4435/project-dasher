extends Area2D

func area_entered(area: Area2D):
	if area.is_in_group("Notes"):
		print("Notes collided")
	print("something collided")
	
func body_entered(body: Node2D):
	print("some body entered")
	pass
