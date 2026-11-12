extends Control

func _ready() -> void:
	get_tree().paused = false
	var bg := ColorRect.new()
	bg.color = UIFactory.BG
	UIFactory.set_full_rect(bg)
	add_child(bg)
	var center := CenterContainer.new()
	UIFactory.set_full_rect(center)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(580, 590)
	panel.add_theme_stylebox_override("panel", UIFactory.style(UIFactory.PANEL, 22, Color("55334b"), 2))
	center.add_child(panel)
	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 18)
	panel.add_child(content)
	var title := UIFactory.label("GAME OVER", 52, UIFactory.DANGER)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	var reason := UIFactory.label(GameState.game_over_reason, 18, UIFactory.MUTED)
	reason.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(reason)
	var stats := UIFactory.label("Pontuação final: %d\n\nAcertos: %d\nErros: %d\nNível alcançado: %d" % [GameState.final_score, GameState.final_correct, GameState.final_errors, GameState.final_level], 24)
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(stats)
	var again := UIFactory.button("JOGAR NOVAMENTE")
	again.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	again.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Game.tscn"))
	content.add_child(again)
	var menu := UIFactory.button("MENU PRINCIPAL")
	menu.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	menu.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	content.add_child(menu)
	again.grab_focus()

