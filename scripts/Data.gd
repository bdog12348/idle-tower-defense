extends Node

const SAVE_DIR = "user://saves/"
const save_pass = "135792468ab"

var player_save_path = SAVE_DIR + "player_save.dat"
var enemy_save_path = SAVE_DIR + "enemy_save.dat"

var gold := float(1000)
var click_damage := float(1)
var wave := float(1)

var basic_enemies_killed := float(0)

enum EnemyTypes {ONE_ENEMY, FIVE_ENEMY, TEN_ENEMY, TWENTY_ENEMY}
enum UpgradeTypes {AUTO_CLICKER, CLICK_POWER, DIGGING}

signal bought_upgrade (type)

var Upgrades = {
	"auto_clicker": {
		"base_price" : float(10),
		"multiplier" : float(1.07),
		"price" : float(0),
		"current_amount" : float(0),
		"type" : UpgradeTypes.AUTO_CLICKER
	},
	"click_power": {
		"base_price" : float(50),
		"multiplier" : float(1.15),
		"price" : float(0),
		"current_amount" : float(0),
		"type" : UpgradeTypes.CLICK_POWER
	},
	"digging_permit": {
		"base_price" : float(250),
		"multiplier" : float(1.15),
		"price" : float(0),
		"current_amount" : float(0),
		"type" : UpgradeTypes.DIGGING
	}
}

const EnemyMultipliers = {
	"basic_enemy" : float(1.07),
}


func _ready():
	load_data()


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


func update_upgrade_prices():
	for key in Upgrades.keys():
		var upgrade = Upgrades[key]
		upgrade["price"] = upgrade["base_price"] * pow(upgrade["multiplier"], upgrade["current_amount"])


func save_player_data():
	var player_data = {
		"gold" : gold,
		"click_damage" : click_damage,
		"upgrades" : Upgrades,
		"wave" : wave,
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
	wave = data.wave


func load_enemy_data(data):
	basic_enemies_killed = data.basic_enemies_killed
