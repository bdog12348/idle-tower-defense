extends Node2D

class_name Bullet

export (Vector2) var velocity
export (float) var damage

func _ready():
	$Area2D.connect("body_entered", self, "kill")


func _physics_process(delta):
	position += velocity * delta


func kill(other):
	if other.is_in_group("Enemy"):
		other.get_parent().take_damage(damage)
	for child in get_children():
		child.queue_free()
	queue_free()
