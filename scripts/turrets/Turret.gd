extends Sprite

class_name Turret

var target
var manned = false
var moving = false

var worker

var all_enemies = []

var Bullet = preload("res://scenes/turrets/bullets/BasicBullet.tscn")

onready var turret_gun = $turret_gun

var canShoot = true
var reloading = false

export (int) var max_shots_per_mag
var current_num_shots

export (float) var bullet_fire_offset = 30
export (float) var shot_cooldown = 2
export (float) var reload_cooldown = 4

onready var enemy_manager = get_tree().root.get_node("Node2D/EnemyManager")

func _ready():
	$ShotProgress.max_value = max_shots_per_mag
	current_num_shots = max_shots_per_mag
	
	connect_children()


func connect_children():
	if enemy_manager:
		enemy_manager.connect("enemy_created", self, "add_enemy")
		enemy_manager.connect("enemy_removed", self, "remove_enemy")
		enemy_manager.connect("clear_all", self, "clear_enemies")

	$Tween.connect("tween_all_completed", self, "_on_Tween_completed")

	$ReloadTimer.wait_time = reload_cooldown
	$ReloadTimer.connect("timeout", self, "_on_ReloadTimer_timeout")

	$Area2D.connect("input_event", self, "input_handler")


func _process(_delta):
	set_target()
	if target != null:
		turret_gun.look_at(target.get_global_position())

	if manned and all_enemies.size() > 0:
		fire_bullet()

	$ShotProgress.value = current_num_shots

	if Input.is_action_just_pressed("m"):
		moving = !moving

	if moving:
		$Highlight.visible = true
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = get_parent().get_parent().map_to_world(get_parent().get_parent().world_to_map(mouse_pos))
		position = Vector2(tile_pos.x + 16, tile_pos.y + 16)
	else:
		$Highlight.visible = false


func fire_bullet():
	if not canShoot:
		if not reloading:
			if current_num_shots <= 0:
				reload(reload_cooldown)
				$ReloadTimer.start()
				return
			else:
				
				reload(shot_cooldown)
				return
		else:
			return

	var dir_rot = -turret_gun.rotation + PI/2
	var direction = Vector2(sin(dir_rot), cos(dir_rot))
	var spawn_point = global_position + direction * bullet_fire_offset

	var bullet = Bullet.instance()
	bullet.velocity = bullet.velocity.rotated(turret_gun.rotation)
	bullet.position = spawn_point
	get_tree().root.add_child(bullet)
	current_num_shots -= 1
	canShoot = false


func set_target():
	if all_enemies.size() > 0:
		var closest_enemy = all_enemies[0]
		for enemy in all_enemies:
			var closest_enemy_distance = position.distance_squared_to(closest_enemy.position)
			if position.distance_squared_to(enemy.position) < closest_enemy_distance:
				closest_enemy = enemy

		target = closest_enemy


func add_enemy(enemy):
	all_enemies.append(enemy)


func remove_enemy(enemy):
	all_enemies.erase(enemy)


func clear_enemies():
	all_enemies.clear()


func set_manned():
	manned = true
	$wIndicator.show()
	$ShotProgress.rect_position.y -= 10


func set_unmanned():
	manned = false
	worker = null
	$wIndicator.hide()
	$ShotProgress.rect_position.y += 10


func reload(time):
	if $Tween.is_active():
		return
		
	reloading = true
	$ShotProgress/ReloadProgress.show()
	$Tween.interpolate_property($ShotProgress/ReloadProgress, "value", 1, 0, time)
	$Tween.start()


func input_handler(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and not moving:
		fire_bullet()


func _on_Tween_completed():
	$ShotProgress/ReloadProgress.hide()
	canShoot = true
	reloading = false
	$Tween.reset_all()


func _on_ReloadTimer_timeout():
	current_num_shots = max_shots_per_mag
	print("reset num shots")

