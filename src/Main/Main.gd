extends Node2D

var player_hp = 0

const SPIKE_TILE = 13

func _ready():
	pass
#	var cells = $"Tiles/World".get_used_cells()
#	for cell in cells:
#		var index = $"Tiles/World".get_cell(cell.x, cell.y)
#		print(index)

func _physics_process(delta):
	pass

func _on_Player_collided(collision):
	if collision.collider is TileMap:
		var tile_pos = collision.collider.world_to_map($Players/Player.position)
		tile_pos -= collision.normal * 1.5

		var tile = collision.collider.get_cellv(tile_pos)

		if tile == SPIKE_TILE:
			player_hp += 1
			print("Hit Spike: ", player_hp)

#		print(tile, tile_pos)
