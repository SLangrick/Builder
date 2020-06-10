extends TileMap

var zones = []
var Freetime_Activities = []

func _ready():
	var obj = preload("res://Scripts/Zone.gd").new(Vector2(2,7), Vector2(7,11), "Dorm")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
	zones.append(obj)
	
	obj = preload("res://Scripts/Zone.gd").new(Vector2(2,13), Vector2(7,19), "Great Hall")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
	zones.append(obj)
	
	obj = preload("res://Scripts/Zone.gd").new(Vector2(12,7), Vector2(17,13), "Alchemy")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
			obj.Is_Class = 1
	zones.append(obj)
	
	obj = preload("res://Scripts/Zone.gd").new(Vector2(12,18), Vector2(17,24), "Divination")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
			obj.Is_Class = 4
	zones.append(obj)
	
	obj = preload("res://Scripts/Zone.gd").new(Vector2(19,7), Vector2(26,13), "Nature")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
			obj.Is_Class = 7
	zones.append(obj)
	
	obj = preload("res://Scripts/Zone.gd").new(Vector2(19,18), Vector2(26,24), "Illusion")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
			obj.Is_Class = 6
	zones.append(obj)
	
	obj = preload("res://Scripts/Zone.gd").new(Vector2(12,26), Vector2(17,31), "Library")
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
	zones.append(obj)

func set_zone_seat(activity):
	for i in zones:
		if i.get_type() == str(activity) and i.get_Unassinged_Number() > 0:
			var seat = i.get_seat()
			return seat
	return -1

func get_zone_seats(activity):
	var seats = 0
	for i in zones:
		if i.get_type() == str(activity):
			seats = seats + i.get_Unassinged_Number()
	return seats

func remove_assigned_seat(activity, seat):
	for i in zones:
		if i.get_type() == str(activity):
			i.free_seat(seat)
			
func add_zone(pos1, pos2, type):
	var obj = preload("res://Scripts/Zone.gd").new(pos1, pos2, type)
	if type == "Abjuration":
		obj.Is_Class = 0
	elif type == "Alchemy":
		obj.Is_Class = 1
	elif type == "Beastology":
		obj.Is_Class = 2
	elif type == "Conjuration":
		obj.Is_Class = 3
	elif type == "Divination":
		obj.Is_Class = 4
	elif type == "Enchantment":
		obj.Is_Class = 5
	elif type == "Illusion":
		obj.Is_Class = 6
	elif type == "Nature":
		obj.Is_Class = 7
	for i in obj.get_tiles():
		if !$"../Object".get_cell(i.x,i.y) == -1:
			obj.add_objects(i)
	zones.append(obj)
	
func add_object(pos, object):
	for zone in zones:
		if pos in zone.Tiles:
			zone.add_objects(pos)

func get_dorm_beds():
	var beds = 0
	for i in zones:
		if i.get_type() == "Dorm":
			beds = beds + i.get_Unassinged_Number()
	return beds

func set_dorm():
	for i in zones:
		if i.get_type() == "Dorm" and i.get_Unassinged_Number() > 0:
			var bed = i.get_seat()
			return bed
			
func get_classes(class_number):
	var Classes = []
	for i in zones:
		if i.Is_Class > -1:
			if i.get_Free(class_number) > 0:
				if !Classes.has(i.get_type()):
					Classes.append(i.get_type())
	return Classes
			
func set_class(class_number, class_type):
	for i in zones:
		if i.Is_Class == class_type:
			i.set_Class(class_number)
			return

func set_freetime(house):
	Freetime_Activities.append("Cloudwatch")
	Freetime_Activities.append("Cloudwatch")
	var library = get_zone_seats("Library")
	var counter = 0
	while counter < library:
		counter = counter + 1
		Freetime_Activities.append("Library")
	var HouseSeats = get_zone_seats(house)
	counter = 0
	while counter < HouseSeats:
		counter =+ 1
		Freetime_Activities.append("Common")
	#add for other houses
	var num = randi() % Freetime_Activities.size()
	var Activity = Freetime_Activities[num]
	Freetime_Activities.clear()
	return Activity
