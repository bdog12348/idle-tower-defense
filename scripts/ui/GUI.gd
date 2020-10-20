extends MarginContainer

var pauseMenu = preload("res://scenes/ui/PauseMenu.tscn")
var highlight = preload("res://scenes/ui/Highlight.tscn")
var towerMenu = preload("res://scenes/TowerMenu.tscn")

onready var ShopMenu = get_node("../ShopMenu")
onready var goldLabel = $"StatsContainer/Control/Gold Label"
onready var waveLabel = $"StatsContainer/Control/Wave Label"
onready var healthLabel = $"StatsContainer/Control/HP Label"
onready var statsPanel = $"StatsContainer/Control/StatsPanel"

export (Color) var invalidColor
export (Color) var validColor

var shop
var pause

var panelShowing = false

var highlightSpawn
var towerMenuSpawn

onready var tilemap = $"../Map/Navigation2D/TileMap"

const offset_amt = 32

signal start_dig (tower_pos)


func _process(_delta):
	if (Data.gold > 1000):
		goldLabel.text = "Gold: " + scientific_notation(Data.gold)
	else:
		goldLabel.text = "Gold: " + str(stepify(Data.gold, 0.01))
	waveLabel.text = "Wave: " + str(Data.wave)
	healthLabel.text = "HP: " + str(Data.health)
	
	if (Data.wave < Data.max_wave):
		$Control/WaveButtonContainer/NextWaveButton.show()
	else:
		if $Control/WaveButtonContainer/NextWaveButton.visible:
			$Control/WaveButtonContainer/NextWaveButton.hide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if ShopMenu.visible:
			ShopMenu.invis()
		elif pause == null:
			pause = pauseMenu.instance()
			get_tree().root.add_child(pause)
			get_tree().paused = true
#		if highlightSpawn != null:
#			highlightSpawn.queue_free()
#		else:
#			if pause == null and not ShopMenu.visible:
#				pause = pauseMenu.instance()
#				get_tree().root.add_child(pause)
#				get_tree().paused = true
	
	if Input.is_action_just_pressed("save") and shop == null:
		if highlightSpawn == null:
			highlightSpawn = highlight.instance()
			tilemap.add_child(highlightSpawn)
		else:
			highlightSpawn.queue_free()
	
	move_highlight()


func _on_TextureButton_pressed():
	ShopMenu.visible = !ShopMenu.visible
	get_node("StatsContainer/Control").visible = !get_node("StatsContainer/Control").visible
	get_tree().paused = !get_tree().paused


func move_highlight():
	var mouse_pos = tilemap.to_local(get_viewport().get_mouse_position())
	var tile_pos = tilemap.map_to_world(tilemap.world_to_map(mouse_pos))
	
	if highlightSpawn != null:
		var tile_type = tilemap.get_cellv(tilemap.world_to_map(mouse_pos))
		if tile_type != -1:
			highlightSpawn.position = Vector2(tile_pos.x + offset_amt, tile_pos.y + offset_amt)
			if tile_type == 0:
				highlightSpawn.modulate = invalidColor
			elif tile_type == 1:
				highlightSpawn.modulate = validColor
				if Input.is_action_just_pressed("click"):
					if towerMenuSpawn == null:
						towerMenuSpawn = towerMenu.instance()
						var towerMenuLoc = Vector2(tile_pos.x, tile_pos.y)
						print("placing at ", towerMenuLoc)
						towerMenuSpawn.position = towerMenuLoc
						tilemap.add_child(towerMenuSpawn)
						highlightSpawn.queue_free()
					#highlightSpawn.clicked()
#					emit_signal("start_dig", tilemap.world_to_map(mouse_pos))


func scientific_notation(number : float) -> String:
	var sign_ = sign(number)
	number = abs(number)
	if number < 1:
		var exp_ = decimals(number)
		var coeff = sign_ * number * pow(10, exp_)
		return String(coeff) + "e" + String(-exp_)
	elif number >= 10:
		var exp_ = String(number).split(".")[0].length() - 1
		var coeff = sign_ * number / pow(10, exp_)
		return String (stepify(coeff, 0.01)) + "e" + String(exp_)
	else:
		return String(number) + "e0"


func _on_Button_pressed():
	print(panelShowing)
	if not panelShowing:
		$Tween.interpolate_property(statsPanel, "rect_position:y", -410, 77, .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		panelShowing = true
	else:
		$Tween.interpolate_property(statsPanel, "rect_position:y", 77, -410, .5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		panelShowing = false


func _on_NextWaveButton_pressed():
	get_parent().get_node("EnemyManager").next_wave_button_pressed()
