extends Control

onready var clickDamageLabel = $MarginContainer/VBoxContainer/ClickDamageLabel

func _ready():
	Data.connect("bought_upgrade", self, "update_labels")
	update_labels(null)

func update_labels(type):
	clickDamageLabel.text = "Click Damage: " + str(Data.click_damage)
