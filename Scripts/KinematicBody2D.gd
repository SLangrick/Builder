extends KinematicBody2D

export var id = 0
export var speed = 250
onready var Map = $"../../Navigation2D/Floor"
onready var nav : Navigation2D = $"../../Navigation2D"
onready var mainScene = $"../.."

var velocity = Vector2()

var path_navigate : PoolVector2Array
var desired_location = Vector2(0,0)


func _physics_process(delta):
	
	if int(mainScene.get_time()) == 7:
		if desired_location == mainScene.get_end():
			pass
		else:
			desired_location = mainScene.get_end()
			move(desired_location)
	if desired_location == Vector2(0,0):
		desired_location = mainScene.get_random_location()
		move(desired_location)
	else:
		if path_navigate.size() > 0:
			var d: float = position.distance_to(path_navigate[0])
			if d > 5:
				position = position.linear_interpolate(path_navigate[0], (speed * delta)/d)
			else:
				path_navigate.remove(0)
			if path_navigate.empty():
				desired_location = Vector2(0,0)
	get_input()
	velocity = move_and_slide(velocity)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	velocity = velocity.normalized() * speed

func move(location):
	var tile_pos = Map.map_to_world(location)
	tile_pos = Vector2(tile_pos.x , tile_pos.y + Map.cell_size.y / 2)
	path_navigate = nav.get_simple_path(position, tile_pos, false)

func set_focus():
	$Camera2D.make_current()
	
func wait(wait):
	set_physics_process(false)
	yield(get_tree().create_timer(wait), 'timeout')
	set_physics_process(true)
