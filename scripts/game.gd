extends Control

const CELL_SIZE := 32
const COLUMNS := 30
const ROWS := 15
const BOARD_SIZE := Vector2(COLUMNS * CELL_SIZE, ROWS * CELL_SIZE)
const BOARD_POSITION := Vector2(160, 168)

var snake: Snake
var math := MathManager.new()
var answer_tokens: Array[AnswerToken] = []
var operation: Dictionary
var score := 0
var correct_count := 0
var error_count := 0
var lives := 3
var level := 1
var elapsed := 0.0
var step_interval := 0.22
var ended := false
var feedback_tween: Tween

var score_label: Label
var stats_label: Label
var operation_label: Label
var feedback_label: Label
var pause_overlay: Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	build_interface()
	start_game()

func build_interface() -> void:
	var bg := ColorRect.new()
	bg.color = UIFactory.BG
	UIFactory.set_full_rect(bg)
	add_child(bg)

	var header := PanelContainer.new()
	header.position = Vector2(32, 22)
	header.size = Vector2(1216, 122)
	header.add_theme_stylebox_override("panel", UIFactory.style(UIFactory.PANEL, 18, Color("24476d"), 2))
	add_child(header)
	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 26)
	header.add_child(header_row)
	var brand := UIFactory.label("SNAKE\nMATH", 25, UIFactory.PRIMARY)
	brand.custom_minimum_size.x = 150
	brand.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header_row.add_child(brand)
	operation_label = UIFactory.label("Resolva:", 37, UIFactory.TEXT)
	operation_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	operation_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	operation_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(operation_label)
	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 310
	header_row.add_child(right)
	score_label = UIFactory.label("Pontuação: 0  •  Nível: 1", 20, UIFactory.GOLD)
	stats_label = UIFactory.label("Acertos: 0  •  Erros: 0\nVidas: ♥ ♥ ♥", 18)
	right.add_child(score_label)
	right.add_child(stats_label)

	var board_panel := PanelContainer.new()
	board_panel.position = BOARD_POSITION - Vector2(8, 8)
	board_panel.size = BOARD_SIZE + Vector2(16, 16)
	board_panel.add_theme_stylebox_override("panel", UIFactory.style(Color("0e1b30"), 14, Color("31597d"), 3))
	add_child(board_panel)
	var grid := BoardBackground.new()
	grid.position = BOARD_POSITION
	grid.board_size = BOARD_SIZE
	grid.cell_size = CELL_SIZE
	add_child(grid)

	feedback_label = UIFactory.label("", 26, UIFactory.PRIMARY)
	feedback_label.position = Vector2(390, 672)
	feedback_label.size = Vector2(500, 38)
	feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(feedback_label)
	build_pause_overlay()

func build_pause_overlay() -> void:
	pause_overlay = ColorRect.new()
	pause_overlay.color = Color(0.02, 0.04, 0.08, 0.9)
	UIFactory.set_full_rect(pause_overlay)
	pause_overlay.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_overlay.visible = false
	add_child(pause_overlay)
	var center := CenterContainer.new()
	UIFactory.set_full_rect(center)
	pause_overlay.add_child(center)
	var card := VBoxContainer.new()
	card.add_theme_constant_override("separation", 16)
	center.add_child(card)
	var title := UIFactory.label("JOGO PAUSADO", 42, UIFactory.ACCENT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.add_child(title)
	var resume := UIFactory.button("CONTINUAR")
	resume.pressed.connect(toggle_pause)
	card.add_child(resume)
	var restart := UIFactory.button("REINICIAR")
	restart.pressed.connect(restart_game)
	card.add_child(restart)
	var menu := UIFactory.button("MENU PRINCIPAL")
	menu.pressed.connect(go_to_menu)
	card.add_child(menu)

func start_game() -> void:
	snake = Snake.new()
	snake.position = BOARD_POSITION
	add_child(snake)
	snake.setup(COLUMNS, ROWS, CELL_SIZE)
	snake.stepped.connect(on_snake_stepped)
	snake.crashed.connect(end_game)
	new_round()
	update_hud()

func _process(delta: float) -> void:
	if ended or get_tree().paused:
		return
	elapsed += delta
	if elapsed >= step_interval:
		elapsed -= step_interval
		snake.move_one_step()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not ended:
		toggle_pause()
		get_viewport().set_input_as_handled()
		return
	if get_tree().paused or ended:
		return
	if event.is_action_pressed("move_up"):
		snake.set_requested_direction(Vector2i.UP)
	elif event.is_action_pressed("move_down"):
		snake.set_requested_direction(Vector2i.DOWN)
	elif event.is_action_pressed("move_left"):
		snake.set_requested_direction(Vector2i.LEFT)
	elif event.is_action_pressed("move_right"):
		snake.set_requested_direction(Vector2i.RIGHT)

func on_snake_stepped(head_cell: Vector2i) -> void:
	for token in answer_tokens:
		if Vector2i((token.position - BOARD_POSITION) / CELL_SIZE) == head_cell:
			resolve_answer(token)
			return

func resolve_answer(token: AnswerToken) -> void:
	if token.is_correct:
		score += 10
		correct_count += 1
		snake.grow()
		show_feedback("CORRETO! +10", UIFactory.PRIMARY)
	else:
		error_count += 1
		lives -= 1
		show_feedback("ERRADO! Resposta correta: %s" % operation.correct, UIFactory.DANGER)
	update_level()
	update_hud()
	if lives <= 0:
		end_game("Todas as vidas foram perdidas")
	else:
		new_round()

func update_level() -> void:
	level = 1 + int(correct_count / 5)
	step_interval = maxf(0.105, 0.22 - (level - 1) * 0.014)

func new_round() -> void:
	for token in answer_tokens:
		token.queue_free()
	answer_tokens.clear()
	operation = math.generate(level)
	operation_label.text = "Resolva:  %s" % operation.text
	var free_cells: Array[Vector2i] = []
	for y in range(ROWS):
		for x in range(COLUMNS):
			var cell := Vector2i(x, y)
			if not snake.occupies(cell):
				free_cells.append(cell)
	free_cells.shuffle()
	spawn_answer(free_cells.pop_back(), int(operation.correct), true)
	spawn_answer(free_cells.pop_back(), int(operation.wrong), false)

func spawn_answer(cell: Vector2i, value: int, correct: bool) -> void:
	var token := AnswerToken.new()
	token.position = BOARD_POSITION + Vector2(cell * CELL_SIZE)
	add_child(token)
	token.configure(value, correct, CELL_SIZE)
	answer_tokens.append(token)

func update_hud() -> void:
	score_label.text = "Pontuação: %d  •  Nível: %d" % [score, level]
	stats_label.text = "Acertos: %d  •  Erros: %d\nVidas: %s" % [correct_count, error_count, "♥ ".repeat(lives).strip_edges()]

func show_feedback(message: String, color: Color) -> void:
	feedback_label.text = message
	feedback_label.modulate = color
	feedback_label.modulate.a = 1.0
	if feedback_tween and feedback_tween.is_valid():
		feedback_tween.kill()
	feedback_tween = create_tween()
	feedback_tween.tween_interval(1.0)
	feedback_tween.tween_property(feedback_label, "modulate:a", 0.0, 0.45)

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_overlay.visible = get_tree().paused

func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func end_game(reason: String) -> void:
	if ended:
		return
	ended = true
	GameState.save_result(score, correct_count, error_count, level, reason)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

class BoardBackground:
	extends Node2D
	var board_size := Vector2.ZERO
	var cell_size := 32
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, board_size), Color("0e1b30"))
		for x in range(0, int(board_size.x) + 1, cell_size):
			draw_line(Vector2(x, 0), Vector2(x, board_size.y), Color(0.18, 0.31, 0.45, 0.22), 1)
		for y in range(0, int(board_size.y) + 1, cell_size):
			draw_line(Vector2(0, y), Vector2(board_size.x, y), Color(0.18, 0.31, 0.45, 0.22), 1)
