extends Control

export (Texture) var image
export (String) var tower_name

var init_scale

func _ready():
	pass


func _on_Control_mouse_entered():
	init_scale = rect_scale
	$Tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1.15, 1.15), .15)
	$Tween.start()


func _on_Control_mouse_exited():
	$Tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1, 1), .15)
	$Tween.start()
