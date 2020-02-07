extends KinematicBody2D


export(int, 0, 300) var pathLength
export(Color) var pathColor

var pathPool : PoolVector2Array
var movementVector
var passed = false

var counter = 0

func _physics_process(delta):
	counter += 1
	
	if (position.x > 1580):
		queue_free()
	
	if !passed:
		movementVector += calc_move_vec()

		if position.x > get_parent().filterLocation:
			if position.y < 450 - get_parent().filterWidth / 2 or position.y > 450 + get_parent().filterWidth / 2:
				queue_free()
			else:
				passed = true
	
	if passed:
		if get_parent().mass_spectrometer:
			movementVector += 0.02 * movementVector.rotated(-PI / 2)
			if position.x < get_parent().filterLocation:
				queue_free()
		else:
			movementVector += calc_move_vec()
	

	if counter == 5:
		pathPool.append(position)
		if pathPool.size() > pathLength:
			pathPool.remove(0)
		
		counter = 0
	
	
	update()
	
	move_and_slide(movementVector)


func calc_move_vec():
	var move_vec = Vector2(0,0)
	move_vec += get_parent().bFieldStrength * movementVector.rotated(-PI / 2)
	move_vec += Vector2(0, get_parent().eFieldStrength)
	return move_vec


func _draw():
	for pointIndex in range(pathPool.size() - 1):
		draw_line(pathPool[pointIndex] - position, pathPool[pointIndex + 1] - position, pathColor)
	if pathPool.size() > 0:
		draw_line(pathPool[pathPool.size() - 1] - position, Vector2(0,0), pathColor)
	
	#var forceVectorMultipliers = 5
	#draw_line (Vector2(0,0), Vector2(0, forceVectorMultipliers * get_parent().eFieldStrength), Color(1,1,0))
	#draw_line (Vector2(0,0), forceVectorMultipliers * get_parent().bFieldStrength * movementVector.rotated(-PI / 2), Color(0, 1, 1))