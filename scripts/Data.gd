extends Node

const SAVE_DIR = "user://saves/"
const save_pass = "135792468ab"

var player_save_path = SAVE_DIR + "player_save.dat"
var enemy_save_path = SAVE_DIR + "enemy_save.dat"

var gold := float(10)
var click_damage := float(1)
var wave := float(1)

var auto_clickers:= float(0)

var basic_enemies_killed := float(0)

enum EnemyTypes {BASIC_ENEMY}
enum UpgradeTypes {AUTO_CLICKER}

const BaseUpgradePrices = {
	"auto_clicker" : float(10)
}

const UpgradeMultipliers = {
	"auto_clicker" : float(1.07)
}

var UpgradePrices = {}

const EnemyMultipliers = {
	"basic_enemy" : float(1.07),
}


func _ready():
	load_data()


func _process(delta):
	pass


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
			auto_clickers += float(1)
			update_upgrade_prices()


func update_upgrade_prices():
	UpgradePrices = {
		"auto_clicker" : BaseUpgradePrices.auto_clicker * pow(UpgradeMultipliers.auto_clicker, auto_clickers)
	}


func save_player_data():
	var player_data = {
		"gold" : gold,
		"click_damage" : click_damage,
		"auto_clickers" : auto_clickers,
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
	auto_clickers = data.auto_clickers
	

func load_enemy_data(data):
	basic_enemies_killed = data.basic_enemies_killed
