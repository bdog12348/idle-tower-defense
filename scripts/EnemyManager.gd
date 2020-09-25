extends Node2D

export (Array, PackedScene) var enemiesToSpawn

onready var path = $"../Map/Path2D"

var enemies = []

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	#Attack and potentially kill the first enemy in the enemies list 
	if enemies.size() > 0:
		var enemy = enemies.pop_front()
		enemy.take_damage(Data.click_damage)
		if enemy.health <= 0:
			print("killed enemy")
			enemy.destroy()
		else:
			enemies.push_front(enemy)


func _on_BasicEnemyTimer_timeout():
	var spawn = enemiesToSpawn[0].instance()
	enemies.push_back(spawn.get_child(0))
	path.add_child(spawn)
