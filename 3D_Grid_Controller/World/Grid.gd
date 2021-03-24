extends GridMap

export var current_floor : int


func _ready():
	# Place children in grid location
	for child in get_children():
		# Get child coords to nearest grid cell
		var child_location_x = world_to_map(child.translation)[0]
		var child_location_y = world_to_map(child.translation)[1]
		var child_location_z = world_to_map(child.translation)[2]
		# Change child location to grid cell coords
		child.translation = map_to_world(child_location_x, child_location_y, child_location_z)
	pass

# Move child to grid cell, args are child and where the child is headed
func request_move(pawn, direction, test : bool = true):
	# Get current grid cell of child
	var cell_start = world_to_map(pawn.translation)
	# Add direction of child to find next adjacent cell
	#var cell_target = check_collisions(cell_start, direction)
	var cell_target = cell_start + direction
	if test:
		cell_target = check_collisions(cell_start, cell_target, direction)
	######################################################if cell_target.type == "STAIR":
	##########################################################var cell_y = cell_target.y
	if cell_target:
		# Check what's in the target cell
		var cell_type_id = get_cell_item(cell_target.x, current_floor, cell_target.z)
		match cell_type_id:
			# If the cell is empty - move to it
			-1:
				return map_to_world(cell_target.x, current_floor, cell_target.z)
		# Else don't move
		return
	return
	
# Make sure pawn won't collide with wall on the way to target cell
func check_collisions(cell_start, cell_target, direction):
	# If the pawn is moving diagonally
	if direction.x and direction.z:
		# Find most eligible open space
		var new_target = find_open_space(cell_start, direction)
		print (new_target)
		if new_target:
			# If this space is not current space - move there
			if new_target != cell_start:
				return new_target
				
			# If this space is current space - don't move
			elif new_target == cell_start:
				return
		# Otherwise the target space is most eligible space
		else:
			return cell_target	

	# If the player isn't moving diagonally we don't need to worry
	return cell_target

# Look for the most eligible open space
func find_open_space(cell_start, direction):
	# Find the adjacent cells in the direction the pawn is moving
	var cell_x = cell_start + Vector3(direction.x, 0, 0)
	var cell_z = cell_start + Vector3(0, 0, direction.z)
	# Check what's in these cells
	var cell_x_id = get_cell_item(cell_x.x, cell_x.y, cell_x.z)
	var cell_z_id = get_cell_item(cell_z.x, cell_z.y, cell_z.z)
	
	# Find out what to do - if both are open then the pawn moves freely
	if cell_z_id == -1 and cell_x_id == -1:
		return
	
	# If both are walls then the pawn doesn't move from start position
	elif cell_z_id != -1 and cell_x_id != -1:
		print ("blocked!")
		return cell_start
		
	# If only one of them is a wall - pawn slides along them to the open cell
	elif cell_z_id != -1 and cell_x_id == -1:
		print ("blocked!")
		return cell_x
	elif cell_z_id == -1 and cell_x_id != -1:
		print ("blocked!")
		return cell_z
