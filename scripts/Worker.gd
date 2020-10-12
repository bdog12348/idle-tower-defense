extends Sprite

onready var tilemap = get_parent()#.get_node("Navigation2D/TileMap")
onready var nav2d = get_parent().get_parent()

var towers
var target
var path
var speed = 40

func _ready():
	if tilemap:
		towers = tilemap.get_node("TowerManager").get_children()


func _process(delta):
	if towers.size() > 0:
		target = towers[0]
	
	if target != null and path == null:
		print("set a path from: ", position, " to: ", target.position)
		path = nav2d.get_simple_path(position, target.position, true)

	if path != null:
		var move_distance = speed * delta
		move_along_path(move_distance)


func move_along_path(distance):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)


func _on_Area2D_area_entered(area):
	var tower = area.get_parent()
	if tower.is_in_group("Tower"):
		tower.set_manned()
		hide()
