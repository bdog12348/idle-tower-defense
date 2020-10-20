extends Node2D

onready var tilemap = get_parent()
onready var towers = get_children()

var invalidColor = Color.red
var validColor = Color.green

var offset_amt = 32

var move_target

func _ready():
	#get_node("../GUI").connect("start_dig", self, "dig_tower")
	pass
	

func dig_tower(tower_pos):
	pass


func _process(_delta):
	if Input.is_action_just_pressed("build"):
		pass
	
	if move_target != null:
		move_tower()


func move_tower():
	var mouse_pos = tilemap.to_local(get_viewport().get_mouse_position())
	var tile_pos = tilemap.map_to_world(tilemap.world_to_map(mouse_pos))
	var tile_type = tilemap.get_cellv(tilemap.world_to_map(mouse_pos))
	
	move_target.moving = true
	
	if tile_type != -1:
		move_target.position = Vector2(tile_pos.x + offset_amt, tile_pos.y + offset_amt)
		if tile_type == 0:
			move_target.modulate = invalidColor
		elif tile_type == 1:
			move_target.modulate = validColor
			if Input.is_action_just_pressed("click"):
				move_target.modulate = Color.white
				move_target.moving = false
				print(move_target.position)
				move_target = null
