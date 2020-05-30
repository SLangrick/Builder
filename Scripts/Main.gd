extends Node2D

var Student = preload("res://Student.tscn")
onready var SpriteHeads = preload("res://Assets/SpriteHeads.tres")
onready var SpriteBodies = preload("res://Assets/SpriteBody.tres")
onready var tiles = preload("res://Assets/MainTiles.tres")

onready var Highlight = $Area/Highlight
onready var Map = $Area/Navigation2D/Pathable
onready var Build = $Area/ToBuild
onready var Zones = $Area/Zones

export var speed = 400
var velocity = Vector2()
var	last_pos = Vector2(0, 0)

var mouse_click_pos1 = Vector2()

var time: float = 00
var time_mult = 1.0
var paused = false
var hour = 6
var tick

var mouse_pos
var tile_pos

var zone_increase
var Cell_Selected = 4
var Zone_Selected = "Class1"

enum {
	PLAY
	BUILD
}

enum {
	PATH
	ZONE
}
var mode = PLAY
var tile = PATH

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_END):
		while Zones.get_dorm_beds() > 0:
			var student = Student.instance()
			var SpriteHeadIndex = randi() % SpriteHeads.get_tiles_ids().size()
			print(SpriteHeadIndex)
			student.set_variables(random_Student_Variables(), SpriteHeadIndex, 0)
			$Area/Students.add_child(student)
	if Input.is_key_pressed(KEY_R):
		if mode == BUILD:
			if ImportData.tile_data[Zone_Selected].has("Rotate"):
				Zone_Selected = ImportData.tile_data[Zone_Selected].Rotate
				for tile in tiles.get_tiles_ids():
					if Zone_Selected == tiles.tile_get_name(tile):
						Cell_Selected = tile
						Update_Mouse_Highlight()
	if Input.is_key_pressed(KEY_1):
		#time_mult = 1.0
		update_Students("CLASS1")
	if Input.is_key_pressed(KEY_2):
		#time_mult = 2.0
		update_Students("CLASS2")
	if Input.is_key_pressed(KEY_3):
		#time_mult = 3.0
		update_Students("CLASS3")
	if Input.is_key_pressed(KEY_4):
		update_Students("FREE")
	
func _unhandled_input(event: InputEvent) -> void:
	if mode == PLAY:
		pass
	elif mode == BUILD:
		if Input.is_action_just_pressed("mouse_action"):
			mouse_click_pos1 = tile_pos
			if Zones.get_cell(mouse_click_pos1.x, mouse_click_pos1.y) == 4:
				zone_increase = 1
		if Input.is_action_just_released("mouse_action"):
			if Highlight.get_used_cells_by_id(1).size() > 0:
				pass
			else:
				if Cell_Selected == 3:
					var used = Highlight.get_used_cells()
					if zone_increase == 1:
						Zones.increase_zone(mouse_click_pos1,last_pos, Zone_Selected)
					else:
						Zones.add_zone(mouse_click_pos1,last_pos, Zone_Selected)
					for i in used:
						Zones.set_cell(i.x, i.y, Cell_Selected)
			Highlight.clear()
			zone_increase = 0
		if Input.is_action_pressed("mouse_action"): 
			build(tile_pos)

func _process(delta):
	mouse_pos = get_global_mouse_position()
	tile_pos = Highlight.world_to_map(mouse_pos)
	if mode == PLAY:
		pass
	elif mode == BUILD:
		if !Input.is_action_pressed("mouse_action"): 
			if !tile_pos == last_pos:
				Update_Mouse_Highlight()
				Highlight.set_cell(last_pos.x, last_pos.y, -1)
				last_pos = tile_pos
				Highlight.set_cell(tile_pos.x, tile_pos.y, Cell_Selected)
		#Insert Right Click For delete?
	
	if not paused:
		if time > 59:
			time = 00
			hour += 1
		if hour > 23:
			hour = 0
		time += delta * time_mult
		$CanvasLayer/lblWorldTime.text = str(hour) + ":" + str(int(time))
		Schedule()

func _on_CanvasLayer_Mode_Change() -> void:
	if mode == PLAY:
		mode = BUILD
		$CanvasLayer/HBoxContainer/Button.text = "Build Mode"
		$CanvasLayer/HBoxContainer/Button.update()
		$CanvasLayer/ItemList.visible = true
		$CanvasLayer/Tabs.visible = true
		
		$Area/Zones.visible = true
	else:
		mode = PLAY
		$CanvasLayer/HBoxContainer/Button.text = "Play Mode"
		$CanvasLayer/HBoxContainer/Button.update()
		$CanvasLayer/ItemList.visible = false
		$CanvasLayer/Tabs.visible = false
		
		$Area/Zones.visible = false

func random_Student_Variables():
	randomize()
	var Gender
	var FirstName
	var LastName
	var Age
	var Grade
	var Spell = [0,0,0]
	var Magic = [1,2,3,4,5,6,7,8]
	var Dorm = Zones.set_dorm()
	
	Gender = randi() % 2
	
	var Names = []
	var file = File.new()
	if Gender == 0:
		file.open("res://FirstMaleNames.txt", file.READ)
	else:
		file.open("res://FirstFemaleNames.txt", file.READ)
		
	while !file.eof_reached ( ):
		var add = file.get_csv_line(",")
		Names.append(add)
	FirstName = Names[(randi() % (Names.size() - 1))]
	file.close()
	
	Names.clear()
	file = File.new()
	file.open("res://LastNames.txt", file.READ)
	while !file.eof_reached ( ):
		var add = file.get_csv_line(",")
		Names.append(add)
	LastName = Names[(randi() % (Names.size() - 1))]
	file.close()
	
	for i in range(0, Spell.size()):
		Spell[i] = randi() % 31
	for i in range(0, Magic.size()):
		Magic[i] = randi() % 21
	
	var Classes = []
	Classes.append(set_class(Classes,"CLASS1",Magic))
	Classes.append(set_class(Classes,"CLASS2",Magic))
	Classes.append(set_class(Classes,"CLASS3",Magic))
	
	print(str(Classes))
	var Content = [Gender, FirstName[0], LastName[0], 11, 1, Spell, Magic, Dorm, Classes]
	return Content

func set_class(Classes, class_number, Magic):
	var free = Zones.get_classes(class_number)
	for i in Classes:
		if free.has(i):
			free.erase(i)
	if free.size() == 0:
		return "FREE"
	var BestClassNum = -1
	var BestClass
	var BestClassID
	for i in free:
		if i == "Abjuration":
			if Magic[0] > BestClassNum:
				BestClassNum = Magic[0]
				BestClass = i
				BestClassID = 0
		elif i == "Alchemy":
			if Magic[1] > BestClassNum:
				BestClassNum = Magic[1]
				BestClass = i
				BestClassID = 1
		elif i == "Beastology":
			if Magic[2] > BestClassNum:
				BestClassNum = Magic[2]
				BestClass = i
				BestClassID = 2
		elif i == "Conjuration":
			if Magic[3] > BestClassNum:
				BestClassNum = Magic[3]
				BestClass = i
				BestClassID = 3
		elif i == "Divination":
			if Magic[4] > BestClassNum:
				BestClassNum = Magic[4]
				BestClass = i
				BestClassID = 4
		elif i == "Enchantment":
			if Magic[5] > BestClassNum:
				BestClassNum = Magic[5]
				BestClass = i
				BestClassID = 5
		elif i == "Illusion":
			if Magic[6] > BestClassNum:
				BestClassNum = Magic[6]
				BestClass = i
				BestClassID = 6
		elif i == "Nature":
			if Magic[7] > BestClassNum:
				BestClassNum = Magic[7]
				BestClass = i
				BestClassID = 7
	Zones.set_class(class_number, BestClassID)
	if BestClass == null:
		print("here")
	return BestClass
	

func Update_Mouse_Highlight():
	Highlight.set_cell(last_pos.x, last_pos.y, -1)
	last_pos = tile_pos
	Highlight.set_cell(tile_pos.x, tile_pos.y, Cell_Selected)

func get_time():
	return int(time)

func Schedule():
	if !int(time) == tick:
		tick = int(time)
		
		if hour == 6 and int(time) == 30:
			update_Students("Great Hall")
		elif hour == 8 and int(time) == 30:
			update_Students("CLASS1")
		elif hour == 10 and int(time) == 30:
			update_Students("CLASS2")
		elif hour == 12 and int(time) == 00:
			update_Students("Great Hall")
		elif hour == 14 and int(time) == 00:
			update_Students("CLASS3")
		elif hour == 15 and int(time) == 30:
			update_Students("FREE")
		elif hour == 17 and int(time) == 30:
			update_Students("Great Hall")
		elif hour == 21 and int(time) == 00:
			update_Students("Dorm")

func update_Students(activity):
	for i in $Area/Students.get_children():
			i.remove_seat()
	for i in $Area/Students.get_children():
			i.set_activity(activity)
	
func build(tile_pos):
	
	#select tile
	#set to this tile
	#zone mode or tile mode
	if Cell_Selected == 3:
		zone(tile_pos)
	else:
		Build.set_cell(tile_pos.x, tile_pos.y, Cell_Selected)

func zone(tile_pos):
	if !tile_pos == last_pos:
		Highlight.clear()
		last_pos = tile_pos
	tile_pos = Highlight.world_to_map(get_global_mouse_position())
	var rows = tile_pos.x - mouse_click_pos1.x
	var colums = tile_pos.y - mouse_click_pos1.y
	var i = 0
	var j = 0
	if rows >= 0 and colums >= 0:
		while i < (rows + 1):
			while j < (colums + 1):
				zone_highlight(i,j)
				j = j + 1
			i = i + 1
			j = 0
	elif rows <= 0 and colums >= 0:
		while i > (rows - 1):
			while j < (colums + 1):
				zone_highlight(i,j)
				j = j + 1
			i = i - 1
			j = 0
	elif rows <= 0 and colums <= 0:
		while i > (rows - 1):
			while j > (colums - 1):
				zone_highlight(i,j)
				j = j - 1
			i = i - 1
			j = 0
	elif rows >= 0 and colums <= 0:
		while i < (rows + 1):
			while j > (colums - 1):
				zone_highlight(i,j)
				j = j - 1
			i = i + 1
			j = 0

func zone_highlight(i,j):
	var x = mouse_click_pos1.x + i
	var y = mouse_click_pos1.y + j
	if Zones.get_cell(x,y) == 3:
		Highlight.set_cell(x,y,1)
	else:
		Highlight.set_cell(x,y,Cell_Selected)

func _on_ItemList_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.

func _on_Button_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.

func cell_selected(cell_id, zone_selected):
	Cell_Selected = cell_id
	Zone_Selected = zone_selected
