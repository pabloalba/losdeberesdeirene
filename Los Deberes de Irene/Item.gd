extends Node2D

const COLOR_BLACK = Color(0, 0, 0)
signal item_selected
var text = ""
var bg_file = preload("res://assets/item_file_bg.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ColorRectSelected").visible = false

func init(txt, texture):
	text = txt
	get_node("VBoxContainer/Label").text = text
	get_node("VBoxContainer//TextureRect").texture = texture
	var width = get_node("TextureRect").rect_size.x - 50
	var font = get_node("VBoxContainer/Label").get_font("font")
	font = font.duplicate()
	get_node("VBoxContainer/Label").set("custom_fonts/font", font)
	
	while font.get_string_size(text).x > width:
		font.size -= 1



func _on_Button_pressed():
	emit_signal("item_selected", text)


func _on_VBoxContainer_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.pressed:
				emit_signal("item_selected", self)

func set_is_file(is_file):
	if is_file:
		get_node("TextureRect").texture = bg_file
		get_node("VBoxContainer/Label").set("custom_colors/font_color", COLOR_BLACK)		

func select():
	get_node("ColorRectSelected").visible = true
	
func show_bookmark(show):
	get_node("TextureRectBookMark").visible = show