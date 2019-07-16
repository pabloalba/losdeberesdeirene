extends Node2D

var label
var color
var background
var font
const RED = Color(255, 0, 0)
const BLUE = Color(0, 0, 255)
const BLACK = Color(0, 0, 0)
const SMALL = 24
const MEDIUM = 48
const BIG = 96
const FONT_SMALL = preload("res://woodfordbourne24.tres")
const FONT_MEDIUM = preload("res://woodfordbourne48.tres")
const FONT_BIG = preload("res://woodfordbourne96.tres")

var size = MEDIUM


func _ready():
	label = get_node("Label")
	background = get_node("ColorRect")
	font = get_node("Label").get_font("font")
	background.rect_size.x = 0

func set_text(text):
	label.text = text
	_update_width()

func _update_width():
	if label.text != "":
		background.rect_size.x = font.get_string_size(label.text).x
	else:
		background.rect_size.x = size / 2
	
	
func select():
	background.visible = true
	
func unselect():
	background.visible = false
	
func get_text():
	return label.text
	
func go_black():
	color = BLACK
	label.set("custom_colors/font_color", BLACK)
	
func go_blue():
	color = BLUE
	label.set("custom_colors/font_color", BLUE)
	
func go_red():
	color = RED
	label.set("custom_colors/font_color", RED)
	
func go_small():
	size = SMALL
	label.set("custom_fonts/font", FONT_SMALL)
	font = FONT_SMALL
	_update_width()
	background.rect_size.y = SMALL
	#background.rect_position.y = SMALL / global.LABEL_CURSOR_FIX
	
	
func go_medium():
	size = MEDIUM
	label.set("custom_fonts/font", FONT_MEDIUM)
	font = FONT_MEDIUM
	_update_width()
	background.rect_size.y = MEDIUM
	#background.rect_position.y = MEDIUM / global.LABEL_CURSOR_FIX
	
func go_big():
	size = BIG
	label.set("custom_fonts/font", FONT_BIG)
	font = FONT_BIG
	_update_width()
	background.rect_size.y = BIG
	#background.rect_position.y = 0#BIG / global.LABEL_CURSOR_FIX