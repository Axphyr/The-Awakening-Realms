extends Node2D

signal done

func start():
	var bitmap := BitMap.new()
	bitmap.create(Vector2(10, 9))
	
	var head := Vector2(9, 0)
	var dir := Vector2.LEFT
	
	await get_tree().create_timer(0.7).timeout
	$audio.play()
	
	while true:
		if bitmap.get_bit(head.x, head.y):
			break

		await get_tree().create_timer(0.01).timeout
		bitmap.set_bit(head.x, head.y, true)
		
		var s = $square.duplicate()
		add_child(s)
		s.position = head * 16.0

		var next_head = head + dir
		if not Rect2(Vector2(), Vector2(10, 9)).has_point(next_head) or bitmap.get_bit(next_head.x, next_head.y):  # Change here
			dir = dir.rotated(deg_to_rad(-90))
			dir.x = round(dir.x)
			dir.y = round(dir.y)

		head += dir
	
	await get_tree().create_timer(0.7).timeout
	
	emit_signal("done")
	queue_free()
