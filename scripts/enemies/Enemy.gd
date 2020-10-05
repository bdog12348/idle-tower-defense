extends Sprite

class_name Enemy

onready var path_follow = get_parent()

export (float) var health
export (float) var speed
export (float) var goldValue
export (float) var damage
export (Color) var colorTint

onready var bar = $TextureProgress

signal died (enemy)

func _ready():
	bar.max_value = health
	bar.value = health
	modulate = colorTint
	
	
func _physics_process(delta):
	movement_loop(delta);
	
	
func movement_loop(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)


func reached_end():
	print("you took " + str(damage) + " damage")
	
	get_parent().queue_free()
	
	for child in get_children():
		child.queue_free()

	queue_free()
	

func take_damage(amount):
	health -= amount
	
	if health <= 0:
		emit_signal("died", self)
	
	bar.value = health


func destroy():
	Data.gold += goldValue
	
	print("got " + str(goldValue) + " gold")
	print("now have " + str(Data.gold) + " total gold")
	
	get_parent().queue_free()
	
	for child in get_children():
		child.queue_free()

	queue_free()


func _on_ShotTimer_timeout():
	pass # Replace with function body.
