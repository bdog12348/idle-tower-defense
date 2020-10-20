extends Node2D

class_name Bullet

export (Vector2) var velocity
export (float) var damage

func _ready():
	$Area2D.connect("area_entered", self, "attack")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")


func _physics_process(delta):
	position += velocity * delta


func attack(other):
	if other.is_in_group("Enemy"):
		other.get_parent().take_damage(damage)
	for child in get_children():
		child.queue_free()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	for child in get_children():
		child.queue_free()
	queue_free()
