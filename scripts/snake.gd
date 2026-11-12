class_name Snake
extends Node2D

signal stepped(head_cell: Vector2i)
signal crashed(reason: String)

var cells: Array[Vector2i] = []
var direction := Vector2i.RIGHT
var queued_direction := Vector2i.RIGHT
var pending_growth := 0
var cell_size := 32
var columns := 30
var rows := 16
var active := true

func setup(grid_columns: int, grid_rows: int, size: int) -> void:
	columns = grid_columns
	rows = grid_rows
	cell_size = size
	cells = [Vector2i(7, 8), Vector2i(6, 8), Vector2i(5, 8), Vector2i(4, 8)]
	direction = Vector2i.RIGHT
	queued_direction = direction
	pending_growth = 0
	active = true
	queue_redraw()

func set_requested_direction(next_direction: Vector2i) -> void:
	if next_direction + direction != Vector2i.ZERO:
		queued_direction = next_direction

func grow() -> void:
	pending_growth += 1

func move_one_step() -> void:
	if not active:
		return
	direction = queued_direction
	var new_head := cells[0] + direction
	if new_head.x < 0 or new_head.y < 0 or new_head.x >= columns or new_head.y >= rows:
		active = false
		crashed.emit("Colisão com a parede")
		return
	var collision_body := cells
	if pending_growth == 0:
		collision_body = cells.slice(0, cells.size() - 1)
	if new_head in collision_body:
		active = false
		crashed.emit("Colisão com o próprio corpo")
		return
	cells.push_front(new_head)
	if pending_growth > 0:
		pending_growth -= 1
	else:
		cells.pop_back()
	queue_redraw()
	stepped.emit(new_head)

func occupies(cell: Vector2i) -> bool:
	return cell in cells

func _draw() -> void:
	for i in range(cells.size() - 1, -1, -1):
		var p := Vector2(cells[i] * cell_size)
		var rect := Rect2(p + Vector2(3, 3), Vector2(cell_size - 6, cell_size - 6))
		if i == 0:
			draw_style_box(UIFactory.style(Color("52e084"), 9), rect)
			draw_circle(p + Vector2(cell_size, cell_size) * 0.5 + Vector2(direction.y, -direction.x) * 6, 2.2, Color("08150e"))
			draw_circle(p + Vector2(cell_size, cell_size) * 0.5 - Vector2(direction.y, -direction.x) * 6, 2.2, Color("08150e"))
		else:
			var shade := Color("38b96b") if i % 2 == 0 else Color("2fa75e")
			draw_style_box(UIFactory.style(shade, 8), rect)

