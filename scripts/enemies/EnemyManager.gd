extends Node2D

onready var path = $"../Map/Navigation2D/TileMap/Path2D"

export (PackedScene) var particleToSpawn
export (Array, PackedScene) var enemy_array

var enemies = []
var enemiesSpawned = 0
var totalNumEnemiesToSpawn
var enemies_to_spawn

var wave_over = false

var currentWaveNum

const ENEMY_DIVISORS = [1, 5, 10, 20]


signal enemy_created(enemy)
signal enemy_removed(enemy)
signal clear_all()


func _ready():
	$WaveTimer.start()


func _process(_delta):
	if enemies.size() == 0 and $WaveTimer.is_stopped() == true and currentWaveNum == 0: #and enemiesSpawned == totalNumEnemiesToSpawn
		wave_over = true

	if Data.health <= 0:
		wave_over = true

	if wave_over:
		handle_wave_over()


func handle_wave_over():
	if enemies.size() > 0 or currentWaveNum > 0 or Data.health <= 0:
		if Data.wave == Data.max_wave:
			Data.wave -= 1
		
		Data.health = Data.max_health
		wave_over = false
		reset_wave()
		$WaveTimer.start()
		
		return
	if Data.wave == Data.max_wave:
		Data.wave += float(1)
	$WaveTimer.start()
	wave_over = false


func attack_enemy(mouse_pos):
	if enemies.size() > 0:
		var closest_path = enemies[0].get_parent()
		for i in path.get_children():
			var enemy_distance = i.position.distance_to(mouse_pos)
			if enemy_distance < closest_path.position.distance_to(mouse_pos):
				closest_path = i
		var closest_enemy = closest_path.get_children()[0]
		
		var enemy_pos = enemies.find(closest_enemy)
		var enemy = enemies[enemy_pos]
		enemy.take_damage(Data.click_damage)


func make_into_wave(num_of_enemies):
	enemiesSpawned = float(0)
	currentWaveNum = num_of_enemies
	
	for i in range(ENEMY_DIVISORS.size()):
		var num_divisors_to_spawn = int(num_of_enemies / ENEMY_DIVISORS[ENEMY_DIVISORS.size() - 1 - i])
		num_of_enemies = fmod(num_of_enemies , ENEMY_DIVISORS[ENEMY_DIVISORS.size() - 1 - i])
		
		enemies_to_spawn[enemy_array[enemy_array.size() - 1 - i]] =  num_divisors_to_spawn
	
	totalNumEnemiesToSpawn = 0
	for i in enemies_to_spawn.values():
		totalNumEnemiesToSpawn += i


func get_enemy(target_num):
	var current_num = 0
	for i in enemies_to_spawn.keys():
		current_num += enemies_to_spawn[i]
		
		if current_num >= target_num:
			var returnEnemy = i.instance()
			return returnEnemy


func make_enemy(type, offset = null, amount = 1):
	for i in range(amount):
		var spawn = enemy_array[type].instance()
		var spawnEnemy = spawn.get_children()[0]
		spawnEnemy.connect("died", self, "enemy_died")
		if offset != null:
			spawn.offset = offset - i * 75
			
		emit_signal("enemy_created", spawn)
		enemies.append(spawnEnemy)
		path.add_child(spawn)


func enemy_died(enemy):
	var enemy_pos = enemies.find(enemy)
	emit_signal("enemy_removed", enemy.get_parent())
	enemy.destroy()
	enemies.remove(enemy_pos)


func enemy_reached_end(enemy):
	enemies.erase(enemy)
	emit_signal("enemy_removed", enemy.get_parent())


func spawn_enemy():
	var spawned = get_enemy(enemiesSpawned + 1)
	var spawnedEnemy = spawned.get_children()[0]
	spawnedEnemy.connect("died", self, "enemy_died")
	spawnedEnemy.connect("hit_end", self, "enemy_reached_end")
	path.add_child(spawned)
	enemies.append(spawnedEnemy)
	emit_signal("enemy_created", spawned)
	enemiesSpawned += 1
	
	if enemiesSpawned >= totalNumEnemiesToSpawn:
		$EnemySpawnTimer.stop()
		var nextWaveNum = currentWaveNum - totalNumEnemiesToSpawn
		if nextWaveNum > 0:
			make_into_wave(nextWaveNum)
			if enemiesSpawned < totalNumEnemiesToSpawn:
				$EnemySpawnTimer.start()
		else:
			currentWaveNum = 0


func _on_WaveTimer_timeout():
	enemies_to_spawn = {}
	make_into_wave(Data.wave)
	
	if enemiesSpawned < totalNumEnemiesToSpawn:
		$EnemySpawnTimer.start()
	$WaveTimer.stop()


func reset_wave():
	for enemy in enemies:
		for child in enemy.get_children():
			child.queue_free()
		enemy.queue_free()
	enemies.clear()
	emit_signal("clear_all")
	$EnemySpawnTimer.stop()


func next_wave_button_pressed():
	if Data.wave < Data.max_wave:
		reset_wave()
		wave_over = false
		Data.wave += 1
		$WaveTimer.start()
