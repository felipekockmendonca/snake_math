extends Control

func _ready() -> void:
	build_interface()

func build_interface() -> void:
	var bg := ColorRect.new()
	bg.color = UIFactory.BG
	UIFactory.set_full_rect(bg)
	add_child(bg)

	var glow := ColorRect.new()
	glow.color = Color("132b49")
	glow.position = Vector2(0, 500)
	glow.size = Vector2(1280, 220)
	bg.add_child(glow)

	var center := CenterContainer.new()
	UIFactory.set_full_rect(center)
	add_child(center)
	var card := VBoxContainer.new()
	card.custom_minimum_size = Vector2(520, 550)
	card.alignment = BoxContainer.ALIGNMENT_CENTER
	card.add_theme_constant_override("separation", 18)
	center.add_child(card)

	var icon := UIFactory.label("◆  +  ×  ÷", 28, UIFactory.ACCENT)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.add_child(icon)
	var title := UIFactory.label("SNAKE MATH", 60, UIFactory.PRIMARY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.add_child(title)
	var subtitle := UIFactory.label("Aprenda matemática enquanto joga!", 22, UIFactory.MUTED)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.add_child(subtitle)
	card.add_child(spacer(28))
	var play := UIFactory.button("JOGAR")
	play.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Game.tscn"))
	card.add_child(play)
	var tutorial := UIFactory.button("COMO JOGAR")
	tutorial.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Tutorial.tscn"))
	card.add_child(tutorial)
	var exit := UIFactory.button("SAIR")
	exit.pressed.connect(func(): get_tree().quit())
	card.add_child(exit)
	card.add_child(spacer(18))
	var team := UIFactory.label("Felipe Kock Mendonça  •  Guilherme Peiter  •  Matheus Tonolli Cordeiro", 14, UIFactory.MUTED)
	team.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.add_child(team)
	play.grab_focus()

func spacer(height: float) -> Control:
	var c := Control.new()
	c.custom_minimum_size.y = height
	return c

