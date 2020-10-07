extends Sprite

class_name Turret

var target
var active = false
var moving = false

var all_enemies = []

var Bullet = preload("res://scenes/turrets/bullets/BasicBullet.tscn")

onready var turret_gun = $turret_gun
onready var timer = $ShotTimer

var canShoot = true

export (float) var bullet_fire_offset = 30
export (float) var shot_cooldown = 2
onready var enemy_manager = $"../../EnemyManager"

func _ready():
	if enemy_manager:
		enemy_manager.connect("enemy_created", self, "add_enemy")
		enemy_manager.connect("enemy_removed", self, "remove_enemy")
	timer.connect("timeout", self, "_on_ShotTimer_timeout")
	timer.wait_time = shot_cooldown
	$Area2D.connect("input_event", self, "input_handler")
	set_turret_inactive()


func _process(_delta):
	if active:
		if Input.is_action_just_pressed("right_click"):
			set_turret_inactive()
		if Input.is_action_just_pressed("click") and canShoot:
			fire_bullet()
		turret_gun.look_at(get_global_mouse_position())
	
	if moving:
		$Highlight.visible = true
	else:
		$Highlight.visible = false


func fire_bullet():
	var dir_rot = -turret_gun.rotation + PI/2
	var direction = Vector2(sin(dir_rot), cos(dir_rot))
	var spawn_point = global_position + direction * bullet_fire_offset

	var bullet = Bullet.instance()
	bullet.velocity = bullet.velocity.rotated(turret_gun.rotation)
	bullet.position = spawn_point
	get_tree().root.add_child(bullet)
	
	canShoot = false
	$Tween.interpolate_property($ShotProgress, "value", 0, 1, shot_cooldown)
	$Tween.start()
	timer.start()
	

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


func set_turret_active():
	active = true
	modulate = Color.white
	turret_gun.modulate = Color.white


func set_turret_inactive():
	active = false
	modulate = Color.gray
	turret_gun.modulate = Color.gray


func input_handler(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and not moving:
		set_turret_active()


func _on_ShotTimer_timeout():
	canShoot = true
