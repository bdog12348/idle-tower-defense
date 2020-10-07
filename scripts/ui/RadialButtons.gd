extends Node2D

export var radius = 120
export var speed = 0.25

var num
var active = false

var delay = 0
var delayAmount = .1

func _ready():
	$Buttons.hide()
	num = $Buttons.get_child_count()
	show_menu()


func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
		
	if active:
		hide_menu()


func show_menu():
	var spacing = TAU / num
	active = true
	for b in $Buttons.get_children():
		# Subtract PI/2 to align the first button  to the top
		var a = spacing * b.get_position_in_parent() - PI / 2
		var dest = Vector2(radius, 0).rotated(a)
		$Tween.interpolate_property(b, "rect_position",
				b.rect_position, dest, speed,
				Tween.TRANS_LINEAR, Tween.EASE_OUT, delay)
		$Tween.interpolate_property(b, "rect_scale",
				Vector2(0.5, 0.5), Vector2.ONE, speed,
				Tween.TRANS_LINEAR, delay)
		delay += delayAmount
	$Tween.start()
	$Buttons.show()


func hide_menu():
	active = false
	$Tween.remove_all()
	for b in $Buttons.get_children():
		$Tween.interpolate_property(b, "rect_position", b.rect_position,
				Vector2.ZERO, speed, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.interpolate_property(b, "rect_scale", Vector2.ONE,
				Vector2(0.5, 0.5), speed, Tween.TRANS_LINEAR)
	$Tween.start()


func _on_Tween_tween_all_completed():
	if not active:
		for child in get_children():
			child.queue_free()
		queue_free()
