extends Sprite

class_name Enemy

onready var path_follow = get_parent()

export (float) var health
export (float) var speed
export (float) var goldValue
export (float) var damage

func _ready():
	pass

func _process(delta):
	pass
	
func _physics_process(delta):
	movement_loop(delta);
	
func movement_loop(delta):
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()

func reached_end():
	print("you took " + str(damage) + " damage")
	
	for child in get_children():
		child.queue_free()

	queue_free()

func take_damage(amount):
	health -= amount

func destroy():
	Data.gold += goldValue
	
	print("got " + str(goldValue) + " gold")
	print("now have " + str(Data.gold) + " total gold")
	
	for child in get_children():
		child.queue_free()

	queue_free()
