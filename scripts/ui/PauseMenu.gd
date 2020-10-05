extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		for child in get_children():
			child.queue_free()
		queue_free()

func _on_QuitButton_pressed():
	Data.save()
	get_tree().quit()


func _on_ContinueButton_pressed():
	get_tree().paused = false
	for child in get_children():
		child.queue_free()
	queue_free()
