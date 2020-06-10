extends Control

var Magic = []

func _ready() -> void:
	Magic = $"../../../Area/Students".get_child(Global.StudentChildID).Magic
	set_progress()
	get_tree().paused = true
	grab_focus()



func _on_Button_pressed() -> void:
	print("Here")
	get_tree().paused = false
	queue_free()


func _on_Button_focus_entered() -> void:
	print("Here")
	get_tree().paused = false
	queue_free()

func set_progress():
	#var Abjuration = 0 #Healing + Defense
#var Alchemy = 0 #Produce Potions
#var Beastology = 0 #Tame Beasts
#var Conjuration = 0 #Summon Weapons or Creatures
#var Divination = 0 #Look into the future
#var Enchantment = 0 #Enchant Items
#var Illusion = 0 #Blind, Make copies
#var Nature = 0 #Elemental: Fireballs, Nature: Plants
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer/Label".text = "Abjuration"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer/ProgressBar".value = Magic[0]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer2/Label".text = "Alchemy"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer2/ProgressBar".value = Magic[1]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer3/Label".text = "Beastology"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer3/ProgressBar".value = Magic[2]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer4/Label".text = "Conjuration"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer4/ProgressBar".value = Magic[3]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer5/Label".text = "Divination"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer5/ProgressBar".value = Magic[4]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer6/Label".text = "Enchantment"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer6/ProgressBar".value = Magic[5]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer7/Label".text = "Illusion"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer7/ProgressBar".value = Magic[6]
	
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer8/Label".text = "Nature"
	$"CenterContainer/Panel/VBoxContainer/HBoxContainer8/ProgressBar".value = Magic[7]
