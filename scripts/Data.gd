extends Node

const SAVE_DIR = "user://saves/"
const save_pass = "135792468ab"

var player_save_path = SAVE_DIR + "player_save.dat"
var enemy_save_path = SAVE_DIR + "enemy_save.dat"

var gold := float(75)
var click_damage := float(1)
var wave := float(1)
var max_wave := float(0)
var num_towers := float(0)
var health := float(5)
var max_health := float(5)

var workers_owned := float(0)
var worker_base_price := float(75)
var worker_current_price := float(75)
var worker_exp := float(1.1)

var basic_enemies_killed := float(0)

enum EnemyTypes {ONE_ENEMY, FIVE_ENEMY, TEN_ENEMY, TWENTY_ENEMY}

enum UpgradeTypes { 
		BASIC_TURRET_DAMAGE, BASIC_TURRET_RELOAD, 
	}
	
enum TurretTypes {BASIC_TURRET}

signal bought_upgrade (type)
signal worker_bought ()

var Towers = {
	"basic_turret": {
		"base_price" : float(5),
		"multiplier" : float(1.07),
		"price" : float(5),
		"amount_in_inventory" : float(0),
		"current_amount" : float(1),
		"type": TurretTypes.BASIC_TURRET
	}
}

var Upgrades = {
	"basic_turret_damage": {
		"base_price" : float(5),
		"multiplier" : float(1.07),
		"price" : float(0),
		"current_amount" : float(0),
		"type" : UpgradeTypes.BASIC_TURRET_DAMAGE
	},
	"basic_turret_reload": {
		"base_price" : float(10),
		"multiplier" : float(1.07),
		"price" : float(0),
		"current_amount" : float(0),
		"type" : UpgradeTypes.BASIC_TURRET_RELOAD
	},
}

const EnemyMultipliers = {
	"basic_enemy" : float(1.07),
}


func _ready():
	load_data()


func _process(delta):
	if wave > max_wave:
		max_wave = wave


func addEnemiesKilled(enemyType, amount):
	match(enemyType):
		EnemyTypes.BASIC_ENEMY:
			basic_enemies_killed += float(amount)


func save():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
		
	save_player_data()
	save_enemy_data()
	print("saved")


func load_data():
	var file = File.new()
	if file.file_exists(player_save_path):
		var error = file.open_encrypted_with_pass(player_save_path, File.READ, save_pass)
		if error == OK:
			var saved_player_data = file.get_var()
			print(saved_player_data)
			load_player_data(saved_player_data)
		file.close()
	
	if file.file_exists(enemy_save_path):
		var error = file.open_encrypted_with_pass(enemy_save_path, File.READ, save_pass)
		if error == OK:
			var saved_enemy_data = file.get_var()
			print(saved_enemy_data)
			load_enemy_data(saved_enemy_data)
		file.close()
	
	update_upgrade_prices()
	print("loaded")


func buy_upgrade(type):
	match(type):
		UpgradeTypes.AUTO_CLICKER:
			Upgrades.auto_clicker.current_amount += float(1)
			update_upgrade_prices()
			emit_signal("bought_upgrade", UpgradeTypes.AUTO_CLICKER)
		UpgradeTypes.CLICK_POWER:
			Upgrades.click_power.current_amount += float(1)
			update_upgrade_prices()
			emit_signal("bought_upgrade", UpgradeTypes.CLICK_POWER)
		UpgradeTypes.DIGGING:
			Upgrades.digging_permit.current_amount += 1
			update_upgrade_prices()


func buy_tower(key_in_dict):
	gold -= Towers[key_in_dict].price
	Towers[key_in_dict].current_amount += float(1)
	Towers[key_in_dict].price = Towers[key_in_dict].base_price * pow(Towers[key_in_dict].multiplier, Towers[key_in_dict].current_amount)


func buy_worker():
	gold -= worker_current_price
	workers_owned += 1
	worker_current_price = worker_base_price * pow(worker_exp, workers_owned)
	emit_signal("worker_bought")

func update_upgrade_prices():
	for key in Upgrades.keys():
		var upgrade = Upgrades[key]
		upgrade["price"] = upgrade["base_price"] * pow(upgrade["multiplier"], upgrade["current_amount"])


func save_player_data():
	var player_data = {
		"gold" : gold,
		"click_damage" : click_damage,
		"upgrades" : Upgrades,
		"towers" : Towers,
		"wave" : wave,
		"health" : health,
		"max_health" : max_health,
	}

	var file = File.new()
	var player_open_error = file.open_encrypted_with_pass(player_save_path, File.WRITE, save_pass)
	if player_open_error == OK:
		file.store_var(player_data)
	file.close()


func save_enemy_data():
	var enemy_data = {
		"basic_enemies_killed" : basic_enemies_killed,
	}
	
	var file = File.new()
	var enemy_open_error = file.open_encrypted_with_pass(enemy_save_path, File.WRITE, save_pass)
	if enemy_open_error == OK:
		file.store_var(enemy_data)
	file.close()


func load_player_data(data):
	gold = data.gold
	click_damage = data.click_damage
	Upgrades = data.upgrades
	Towers = data.towers
	wave = data.wave
	health = data.health
	max_health = data.max_health

func load_enemy_data(data):
	basic_enemies_killed = data.basic_enemies_killed


func take_damage(amt):
	health -= amt
