extends Node2D

var label
var color
var background
var font
const FONT_SMALL = preload("res://woodfordbourne24.tres")
const FONT_MEDIUM = preload("res://woodfordbourne48.tres")
const FONT_BIG = preload("res://woodfordbourne96.tres")
const COLOR_RED = Color(255, 0, 0)
const COLOR_BLUE = Color(0, 0, 255)
const COLOR_BLACK = Color(0, 0, 0)

var size = global.MEDIUM


func _ready():
	init()

func init():
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
	color = global.BLACK
	label.set("custom_colors/font_color", COLOR_BLACK)
	
func go_blue():
	color = global.BLUE
	label.set("custom_colors/font_color", COLOR_BLUE)
	
func go_red():
	color = global.RED
	label.set("custom_colors/font_color", COLOR_RED)
	
func go_small():
	size = global.SMALL
	label.set("custom_fonts/font", FONT_SMALL)
	font = FONT_SMALL
	_update_width()
	background.rect_size.y = global.SMALL
	#background.rect_position.y = global.SMALL / global.LABEL_CURSOR_FIX
	
	
func go_medium():
	size = global.MEDIUM
	label.set("custom_fonts/font", FONT_MEDIUM)
	font = FONT_MEDIUM
	_update_width()
	background.rect_size.y = global.MEDIUM
	#background.rect_position.y = global.MEDIUM / global.LABEL_CURSOR_FIX
	
func go_big():
	size = global.BIG
	label.set("custom_fonts/font", FONT_BIG)
	font = FONT_BIG
	_update_width()
	background.rect_size.y = global.BIG
	#background.rect_position.y = 0#global.BIG / global.LABEL_CURSOR_FIX
	
func serialize():
	return {
		"text": get_text(),
		"color": color,
		"size": size,
		"x": position.x,
		"y": position.y			
	}
	
func from_serialization(serialization):	
	init()
	set_text(serialization["text"])
	if serialization["color"] == global.RED:
		go_red()
	elif serialization["color"] == global.BLUE:
		go_blue()
	elif serialization["color"] == global.BLACK:
		go_black()
		
	if serialization["size"] == global.SMALL:
		go_small()
	elif serialization["size"] == global.MEDIUM:
		go_medium()
	elif serialization["size"] == global.BIG:
		go_big()
		
	position.x = serialization["x"]
	position.y = serialization["y"]
	