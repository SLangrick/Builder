extends KinematicBody2D


onready var nav : Navigation2D = $"../Navigation2D"
onready var mainScene = $"../.."
onready var toBuild = $"../ToBuild"
onready var Map = $"../Navigation2D/Pathable"
onready var Objects = $"../Object"
onready var tiles = preload("res://Assets/MainTiles.tres")
onready var Zones = $"../Zones"

export var speed = 250

var path_navigate : PoolVector2Array
var desired_location = Vector2(0,0)

enum {
	IDLE
	MOVE
	BUILD
}

var state = IDLE
var Job_List = []

func _physics_process(delta):
	match state:
		IDLE:
			if !toBuild.Jobs() == -1:
				desired_location = toBuild.set_Job()
				set_build_location(desired_location)
		MOVE:
			move_to_location(delta)
		BUILD:
			build_cell()

func set_build_location(location):
	Job_List.append(MOVE)
	Job_List.append(BUILD)
	Job_List.append(IDLE)
	
	var tile_pos = Map.map_to_world(location)
	tile_pos = Vector2(tile_pos.x , tile_pos.y + Map.cell_size.y / 2)
	path_navigate = nav.get_simple_path(position, tile_pos, false)
	state = Job_List.pop_front()

func move_to_location(delta):
	if path_navigate.size() > 0:
		var d: float = position.distance_to(path_navigate[0])
		if d > 5:
			position = position.linear_interpolate(path_navigate[0], (speed * delta)/d)
		else:
			path_navigate.remove(0)
		if path_navigate.empty():
			state = Job_List.pop_front()

func build_cell():
	var cell_type = toBuild.get_cell(desired_location.x, desired_location.y)
	toBuild.set_cell(desired_location.x, desired_location.y, -1)
	var tile_name = tiles.tile_get_name(cell_type)
	if ImportData.tile_data[tile_name].Type == "Floor" or ImportData.tile_data[tile_name].Type == "Walls":
		Map.set_cell(desired_location.x, desired_location.y, cell_type)
	elif ImportData.tile_data[tile_name].Type == "Objects":
		Objects.set_cell(desired_location.x, desired_location.y, cell_type)
		Zones.add_object(desired_location, cell_type)
	toBuild.delete_assigned(desired_location)
	state = Job_List.pop_front()

func set_focus():
	$Camera2D.make_current()
	
func wait(wait):
	set_physics_process(false)
	yield(get_tree().create_timer(wait), 'timeout')
	set_physics_process(true)



func _on_Player_mouse_entered() -> void:
	$Sprite.visible = true


func _on_Player_mouse_exited() -> void:
	$Sprite.visible = false


func _on_Player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("Worker")
	if event is InputEventMouseButton:
		print("here")
	else:
		return
