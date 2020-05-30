extends Node

onready var SpriteHeads = preload("res://Assets/SpriteHeads.tres")
onready var SpriteBodies = preload("res://Assets/SpriteBody.tres")

func Set_Head(Index, Gender, Direction):
	var SpriteHead = AtlasTexture.new();
	SpriteHead.atlas = SpriteHeads.tile_get_texture(Index)
	SpriteHead.region = SpriteHeads.tile_get_region(Index)
	SpriteHead.region= SpriteHead.region.grow_individual(0,0,-96,0)
	var region = SpriteHead.region.position.y
	SpriteHead.region.position = Vector2(Direction, region)
	return SpriteHead

func Set_Body(Index, Gender, Direction):
	var SpriteBody = AtlasTexture.new();
	SpriteBody.atlas = SpriteBodies.tile_get_texture(Index)
	SpriteBody.region = SpriteBodies.tile_get_region(Index)
	SpriteBody.region= SpriteBody.region.grow_individual(0,0,-96,0)
	SpriteBody.region.position = Vector2(Direction, 0)
	return SpriteBody
