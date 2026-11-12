extends Control

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = UIFactory.BG
	UIFactory.set_full_rect(bg)
	add_child(bg)
	var center := CenterContainer.new()
	UIFactory.set_full_rect(center)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(820, 600)
	panel.add_theme_stylebox_override("panel", UIFactory.style(UIFactory.PANEL, 20, Color("274568"), 2))
	center.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 18)
	panel.add_child(content)
	var title := UIFactory.label("COMO JOGAR", 42, UIFactory.PRIMARY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	var intro := UIFactory.label("Controle a cobrinha e encontre a resposta correta para a operação matemática.", 20)
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(intro)
	add_section(content, "WASD ou Setas", "Movimentar a cobra")
	add_section(content, "Objetivo", "Observe a operação apresentada e coma a resposta correta.")
	add_section(content, "Resposta errada", "Você perde uma vida.")
	add_section(content, "Fim de jogo", "A partida termina quando todas as vidas forem perdidas ou quando a cobra colidir com a parede ou com o próprio corpo.")
	var back := UIFactory.button("VOLTAR", 240)
	back.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	content.add_child(back)
	back.grab_focus()

func add_section(parent: VBoxContainer, heading: String, description: String) -> void:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	var h := UIFactory.label(heading, 21, UIFactory.ACCENT)
	box.add_child(h)
	var d := UIFactory.label(description, 17, UIFactory.MUTED)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(d)
	parent.add_child(box)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

