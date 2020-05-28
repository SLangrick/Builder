extends TileMap

var assigned = []


func _ready() -> void:
	pass # Replace with function body.

func delete_assigned(vector):
	assigned.erase(vector)

func set_Job():
	var used = .get_used_cells()
	
	if !used.empty():
		var unassigned = []
		for v in used:
			if not (v in assigned):
				unassigned.append(v)
		if !unassigned.empty():
			assigned.append(unassigned[0])
			return unassigned[0]

func Jobs():
	var used = .get_used_cells()
	
	if !used.empty():
		var unassigned = []
		for v in used:
			if not (v in assigned):
				unassigned.append(v)
		return unassigned.size()
	else:
		return -1
