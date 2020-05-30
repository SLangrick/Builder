extends KinematicBody2D

onready var nav : Navigation2D = $"../../Navigation2D"
# onready var mainScene = $"../../.."
onready var Map = $"../../Navigation2D/Pathable"
# onready var Objects = $"../../Object"
onready var Zones = $"../../Zones"
onready var Controller = $".."


export var speed = 250

var head_Index
var body_Index

var path_navigate : PoolVector2Array
var Direction
var DirectionString
var desired_location

enum {
	IDLE
	WAITING
	MOVE
	FREE
}
var state = IDLE
var current_activity

var Gender = 0
var FirstName = ""
var LastName = ""
var Age = 11
var Grade = 1
var House = "House1"
var Dorm

var Classes = ["Alchemy", "Conjuration", "Enchanting"]
#Spell Data
var Spell = []
#var Spell_Casting = 0
#var Magic_Principles = 0
#var Magic_Power = 0
#Major Schools
var Magic = []
#var Abjuration = 0 #Healing + Defense
#var Alchemy = 0 #Produce Potions
#var Beastology = 0 #Tame Beasts
#var Conjuration = 0 #Summon Weapons or Creatures
#var Divination = 0 #Look into the future
#var Enchantment = 0 #Enchant Items
#var Illusion = 0 #Blind, Make copies
#var Nature = 0 #Elemental: Fireballs, Nature: Plants

func _physics_process(delta):
	
	
	match state:
		IDLE:
			#insert decision
			desired_location = Dorm
			set_movement_location(desired_location)
		MOVE:
			move_to_location(delta)
		WAITING:
			pass
		FREE:
			#insert house
			desired_location =	Zones.set_freetime(House)
			set_free_location(desired_location)

func set_movement_location(location):
	var tile_pos = Map.map_to_world(location)
	tile_pos = Vector2(tile_pos.x + (Map.cell_size.x / 2), tile_pos.y + (Map.cell_size.y / 1.9))
	path_navigate = nav.get_simple_path(position, tile_pos, false)
	state = MOVE

func remove_seat():
	#Remove from seat array
	if !desired_location == Dorm:
		Zones.remove_assigned_seat(current_activity, desired_location)
		
func set_free_location(location):
	if location == "Cloudwatch":
		var used = Map.get_used_cells_by_id(0)
		var num = randi() % used.size()
		desired_location = Dorm
		set_movement_location(used[num])
	else:
		set_activity(location)
		
func set_activity(activity):
	if current_activity == Classes[0] or current_activity == Classes[1] or current_activity == Classes[2]:
		add_stats()
	#Setting the current activity
	if activity == "CLASS1":
		activity = Classes[0]
	elif activity == "CLASS2":
		activity = Classes[1]
	elif activity == "CLASS3":
		activity = Classes[2]
	current_activity = activity
	#If no class assigned then Free
	if activity == "FREE":
		state = FREE
		return
	#Set seat or If no seats available then free
	if Zones.get_zone_seats(activity) > 0:
		desired_location = Zones.set_zone_seat(activity)
		set_movement_location(desired_location)
	else:
		state = FREE

func move_to_location(delta):
	if path_navigate.size() > 0:
		var d: float = position.distance_to(path_navigate[0])
		if d > 5:
			if !Direction == position.direction_to(path_navigate[0]):
				Direction = position.direction_to(path_navigate[0])
				movement_sprite_change(position.direction_to(path_navigate[0]))
			position = position.linear_interpolate(path_navigate[0], (speed * delta)/d)
		else:
			path_navigate.remove(0)
		if path_navigate.empty():
			state = WAITING
			
func movement_sprite_change(Vect: Vector2):
	var VectX = Vect.x
	var VectY = Vect.y
	if VectX < 0:
		VectX = VectX * -1
	if VectY < 0:
		VectY = VectY * -1
	#32, -64
	#64, -32
	#96, 0
	if VectX > VectY:
		if Vect.x < 0:
			#left
			if !DirectionString == "Left":
				DirectionString = "Left"
				set_sprite(64)
		else:
			#right
			if !DirectionString == "Right":
				DirectionString = "Right"
				set_sprite(96)
	elif VectX < VectY:
		if Vect.y < 0:
			#Down
			if !DirectionString == "Down":
				DirectionString = "Down"
				set_sprite(32)
		else:
			#Up
			if !DirectionString == "Up":
				DirectionString = "Up"
				set_sprite(0)
			
func set_sprite(Direction):
	#Direction = region offset
	var head = Controller.Set_Head(head_Index, Gender, Direction)
	var body = Controller.Set_Body(body_Index, Gender, Direction)
	$Node2D/Head.texture = head
	$Node2D/Body.texture = body
	
#Mouse Input
func _on_Player_mouse_entered() -> void:
	$lblName.visible = true
func _on_Player_mouse_exited() -> void:
	$lblName.visible = false
func _on_Player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print(str(Classes))
			print(str(Magic))
	else:
		return
#Variables on creation
func set_variables(Content, SpriteHead, SpriteBody):
	Gender = Content[0]
	FirstName = Content[1]
	LastName = Content[2]
	Age = Content[3]
	Grade = Content[4]
	Spell = Content[5]
	Magic = Content[6]
	Dorm = Content[7]
	Classes = Content[8]
	$lblName.text = str(FirstName) + " " + str(LastName)
	print($lblName.text)
	
	head_Index = SpriteHead
	body_Index = SpriteBody
	
func add_stats():
	var MagicType = get_magic_number(current_activity)
	Magic[MagicType] = Magic[MagicType] + 1 + (Spell[2]/10)
	
func get_magic_number(school):
	if school == "Abjuration":
		return 0
	elif school  == "Alchemy":
		return 1
	elif school  == "Beastology":
		return 2
	elif school  == "Conjuration":
		return 3
	elif school == "Divination":
		return 4
	elif school  == "Enchantment":
		return 5
	elif school  == "Illusion":
		return 6
	elif school  == "Nature":
		return 7

	print("Gender " + str(Gender))
	print("Name " + FirstName + " " + LastName)
	print("Age " + str(Age))
	print("Grade " + str(Grade))
	print("Alchemy " + str(Magic[1]))
