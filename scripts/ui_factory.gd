class_name UIFactory
extends RefCounted

const BG := Color("0b1324")
const PANEL := Color("13233d")
const PANEL_LIGHT := Color("1b3152")
const PRIMARY := Color("43d17c")
const PRIMARY_HOVER := Color("5bea91")
const ACCENT := Color("54c8ff")
const TEXT := Color("f2f7ff")
const MUTED := Color("a9bad2")
const DANGER := Color("ff6174")
const GOLD := Color("ffd166")

static func style(color: Color, radius: int = 12, border_color: Color = Color.TRANSPARENT, border_width: int = 0) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.corner_radius_top_left = radius
	box.corner_radius_top_right = radius
	box.corner_radius_bottom_left = radius
	box.corner_radius_bottom_right = radius
	box.border_color = border_color
	box.border_width_left = border_width
	box.border_width_right = border_width
	box.border_width_top = border_width
	box.border_width_bottom = border_width
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 12
	box.content_margin_bottom = 12
	return box

static func button(text_value: String, width: float = 280.0) -> Button:
	var b := Button.new()
	b.text = text_value
	b.custom_minimum_size = Vector2(width, 54)
	b.add_theme_font_size_override("font_size", 20)
	b.add_theme_color_override("font_color", Color("07131a"))
	b.add_theme_color_override("font_hover_color", Color("07131a"))
	b.add_theme_stylebox_override("normal", style(PRIMARY, 12))
	b.add_theme_stylebox_override("hover", style(PRIMARY_HOVER, 12))
	b.add_theme_stylebox_override("pressed", style(Color("32ae66"), 12))
	b.add_theme_stylebox_override("focus", style(PRIMARY_HOVER, 12, ACCENT, 2))
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return b

static func label(text_value: String, size: int, color: Color = TEXT) -> Label:
	var l := Label.new()
	l.text = text_value
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l

static func set_full_rect(control: Control) -> void:
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
