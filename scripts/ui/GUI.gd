extends MarginContainer

var pauseMenu = preload("res://scenes/ui/PauseMenu.tscn")
var highlight = preload("res://scenes/ui/Highlight.tscn")

onready var ShopMenu = get_node("../ShopMenu")
onready var goldLabel = $"StatsContainer/Gold Label"
onready var waveLabel = $"StatsContainer/Wave Label"

export (Color) var invalidColor
export (Color) var validColor

var shop
var pause

var highlightSpawn

onready var tilemap = $"../Map/TileMap"


func _process(_delta):
	if (Data.gold > 1000):
		goldLabel.text = "Gold: " + scientific_notation(Data.gold)
	else:
		goldLabel.text = "Gold: " + str(stepify(Data.gold, 0.01))
	waveLabel.text = "Wave: " + str(Data.wave)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if highlightSpawn != null:
			highlightSpawn.queue_free()
		else:
			if pause == null and shop == null:
				pause = pauseMenu.instance()
				get_tree().root.add_child(pause)
				get_tree().paused = true
	
	if Input.is_action_just_pressed("save") and shop == null:
		if highlightSpawn == null:
			highlightSpawn = highlight.instance()
			tilemap.add_child(highlightSpawn)
		else:
			highlightSpawn.queue_free()
	
	move_highlight()


func _on_TextureButton_pressed():
	ShopMenu.visible = !ShopMenu.visible


func move_highlight():
	var mouse_pos = tilemap.to_local(get_viewport().get_mouse_position())
	var tile_pos = tilemap.map_to_world(tilemap.world_to_map(mouse_pos))
	
	if highlightSpawn != null:
		var offset_amt = 32 * tilemap.scale.x
		var tile_type = tilemap.get_cellv(tilemap.world_to_map(mouse_pos))
		if tile_type != -1:
			highlightSpawn.position = Vector2(tile_pos.x + offset_amt, tile_pos.y + offset_amt)
			if tile_type == 0:
				highlightSpawn.modulate = invalidColor
			elif tile_type == 1:
				highlightSpawn.modulate = validColor


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
