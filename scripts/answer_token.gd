class_name AnswerToken
extends Node2D

var value := 0
var is_correct := false
var cell_size := 32
var pulse := 0.0

func configure(number: int, correct: bool, size: int) -> void:
	value = number
	is_correct = correct
	cell_size = size
	scale = Vector2(0.2, 0.2)
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	queue_redraw()

func _draw() -> void:
	var center := Vector2(cell_size, cell_size) * 0.5
	var radius := 15.0 + sin(pulse * 3.0) * 1.2
	draw_circle(center, radius, Color("223f66"))
	draw_arc(center, radius, 0, TAU, 32, UIFactory.ACCENT, 2.0)
	var font := ThemeDB.fallback_font
	var text := str(value)
	var font_size := 17 if text.length() <= 2 else 14
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	draw_string(font, center - Vector2(text_size.x * 0.5, -text_size.y * 0.32), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, UIFactory.TEXT)

