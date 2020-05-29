extends Node2D

onready var Pathable = $Navigation2D/Pathable
onready var Zones = $Zones
onready var Objects = $Object
onready var ToBuild = $ToBuild

var FreeTime_Zones = []
var House1_Zones = []
var Freetime_Activities = []


func _ready() -> void:
	freetime(1)

func freetime(house):
	Freetime_Activities.append(0)
	Freetime_Activities.append(1)
	for i in FreeTime_Zones:
		var type
		type = i.get_type
		var counter = 0
		while counter < i.get_Unassinged_Number():
			counter =+ 1
			if type == "Library":
				Freetime_Activities.append(3)
			
			
	if house == 1:
		for i in House1_Zones:
			var type
			type = i.get_type
			var counter = 0
			while counter < i.get_Unassinged_Number():
				counter =+ 1
				if type == "Library":
					Freetime_Activities.append(2)
	#add for other houses
	var num = randi() % Freetime_Activities.size()
	var value = Freetime_Activities[num]
	if value == 0:
		#cloud watch
#		var used = Pathable.get_used_cells_by_id(0)
#		num = randi() % used.size()
		return "Cloudwatch"
	elif value == 1:
		#change to paper plane or something
		return "Cloudwatch"
	elif value == 2:
		#socialise in common room
		return "Common"
	elif value == 3:
		#socialise in common room
		return "Library"
	elif value == 4:
		#socialise in common room
		return "Duel"
	
