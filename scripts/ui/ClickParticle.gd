extends Particles2D

func _on_Timer_timeout():
	for child in get_children():
		child.queue_free()
		queue_free()

