extends Node

onready var Objects = $Area/Object

var Identity
var Type
var Tiles = []
var Is_Class = -1

var Seating = []
var Taken = []
var unassigned = []

var Seats = 0
var Class1 = 0
var Class2 = 0
var Class3 = 0

func _init(Pos1,Pos2, RoomType):
	var rows = Pos2.x - Pos1.x
	var colums = Pos2.y - Pos1.y
	var i = 0
	var j = 0
	while i < (rows + 1):
		while j < (colums + 1):
			Tiles.append(Vector2(Pos1.x + i, Pos1. y + j))
			j = j + 1
		i = i + 1
		j = 0
	Type = RoomType
	
func add_objects(Vector):
	Seating.append(Vector)
	Seats = Seats + 1
	unassigned.append(Vector)
	
func get_tiles():
	return Tiles
	
func get_room_type():
	return Type

func get_seat():
	var seat = unassigned.pop_front()
	Taken.append(seat)
	return seat
	
func free_seat(seat):
	if Taken.has(seat):
		unassigned.append(seat)
		Taken.erase(seat)

func set_Class(class_number):
	if class_number == "CLASS1":
		Class1 += 1
	elif class_number == "CLASS2":
		Class2 += 1
	elif class_number == "CLASS3":
		Class3 += 1

func get_Free(class_number):
	if class_number == "CLASS1":
		return Seats - Class1
	elif class_number == "CLASS2":
		return Seats - Class2
	elif class_number == "CLASS3":
		return Seats - Class3


func get_Unassinged_Number():
	return unassigned.size()

func get_type():
	return Type
	
