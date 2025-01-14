# Project Luminext - an advanced open-source Lumines spiritual successor
# Copyright (C) <2024> <unfavorable_enhancer>
# Contact : <random.likes.apes@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


extends Block

# Merge special block turns all blocks around into same color when activated

class_name Merge

var merged : bool = false


func _ready() -> void:
	super()
	
	falled_down.connect(_on_fall)
	squared.connect(_squared)


func _on_fall() -> void:
	await get_tree().create_timer(0.01).timeout
	# If we're just silly remastered clone, do work immidiately
	if Data.profile.config["gameplay"]["instant_special"] : _squared()


# Called when merge block is squared
func _squared() -> void:
	if not merged:
		merged = true
		# When squared, turn everyone same color
		for x : int in range(grid_position.x - 2,grid_position.x + 3):
			for y : int in range(grid_position.y - 2, grid_position.y + 3):
				if Data.game.blocks.has(Vector2i(x,y)):
					var block : Block = Data.game.blocks[Vector2i(x,y)]
					if block.is_dying : continue
					if block.is_scanned : continue

					if block.color != color:
						block.color = color
						block._render()
		
		Data.game._add_fx("merge", grid_position, color)
		
		# Remove special gem from self
		$Special.queue_free()
		
		await get_tree().create_timer(0.01).timeout
		Data.game._square_check(-1)

