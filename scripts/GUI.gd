extends MarginContainer

export (PackedScene) var ShopMenu
export (PackedScene) var pauseMenu

onready var goldLabel = $"VBoxContainer/TopBar/HBoxContainer/Gold Label"

var shop
var pause

func _process(delta):
	goldLabel.text = "Gold: " + str(Data.gold)
	
	if Input.is_action_just_pressed("ui_cancel") and shop == null:
		if pause == null:
			pause = pauseMenu.instance()
			get_tree().root.add_child(pause)
			get_tree().paused = true
			
func _on_TextureButton_pressed():
	if shop == null:
		#visible = false
		shop = ShopMenu.instance()
		get_parent().add_child(shop)
		get_tree().paused = true
