extends CanvasLayer


var mode = "Play"

signal Mode_Change
# Called when the node enters the scene tree for the first time.
onready var itemList = $ItemList
onready var tiles = preload("res://Assets/MainTiles.tres")
onready var icons = preload("res://Assets/ZoneIcons.tres")
var tiles_added = []
var zone = ""

func _ready():
	itemList.max_columns = 9
	itemList.fixed_icon_size = Vector2(64,64)
	itemList.icon_mode = ItemList.ICON_MODE_TOP
	itemList.select_mode = ItemList.SELECT_SINGLE
	itemList.same_column_width = true
	Update_Itemlist("Floor")


func Update_Itemlist(type):
	itemList.clear()
	for tile in tiles.get_tiles_ids():
		var tilename = tiles.tile_get_name(tile)
		if ImportData.tile_data.has(tilename):
			var data = ImportData.tile_data[tilename].Visible
			if data == "True":
				data = ImportData.tile_data[tilename].Type
				if data == type:
					var texture = AtlasTexture.new();
					
					texture.atlas = tiles.tile_get_texture(tile)
					texture.region = tiles.tile_get_region(tile)
					itemList.add_item(tilename, texture, true)

func _on_Button_pressed() -> void:
	if mode == "Play":
		mode = "Build"
	else:
		mode = "Play"
	emit_signal("Mode_Change")

func _on_ItemList_item_selected(index: int) -> void:
	for tile in tiles.get_tiles_ids():
		#print(str(tile) + " " + tiles.tile_get_name(tile))
		if itemList.get_item_text(index) == tiles.tile_get_name(tile):
			$"..".cell_selected(tile, tiles.tile_get_name(tile))
	for zone in icons.get_tiles_ids():
		if itemList.get_item_text(index) == icons.tile_get_name(zone):
			$"..".cell_selected(3, icons.tile_get_name(zone))
	


func _on_Zones_pressed() -> void:
	itemList.clear()
	for zone in icons.get_tiles_ids():
		var tilename = icons.tile_get_name(zone)
		var texture = AtlasTexture.new();
		texture.atlas = icons.tile_get_texture(zone)
		texture.region = icons.tile_get_region(zone)
		itemList.add_item(tilename, texture, true)
		


func _on_Paths_pressed() -> void:
	Update_Itemlist("Floor")


func _on_Walls_pressed() -> void:
	Update_Itemlist("Walls")


func _on_Objects_pressed() -> void:
	Update_Itemlist("Objects")
