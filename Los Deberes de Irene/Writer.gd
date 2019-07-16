extends Node2D

const DOCUMENT_WIDTH = 1265
const HEIGHT = 768
const CAMERA_SPEED = 1000
const COLOR_RED = Color(255, 0, 0)
const COLOR_BLUE = Color(0, 0, 255)
const COLOR_BLACK = Color(0, 0, 0)
const FONT_SMALL = 24
const FONT_MEDIUM = 48
const FONT_BIG = 96


var target_width
var target_height
var cursor
var labels
var current_label
var current_label_num
var current_color = COLOR_BLACK
var current_font = FONT_MEDIUM
var label_scene = preload("res://LabelCustomizable.tscn")


func _ready():
	load_docuemnt()
	set_process_input(true)
	cursor = get_node("Cursor")
	cursor.set_as_toplevel(true)
	labels = _load_labels()
	if len(labels) > 0:
		current_label = labels[0]		
	else:				
		_move_cursor(200, 200)
	update_cursor_position()
	
func _load_labels():
	return []

	
func load_docuemnt():
	var texture
	if global.current_file.ends_with(".jpg"):
		texture = global.load_jpg(global.current_file)
	elif global.current_file.ends_with(".png"):
		texture = global.load_png(global.current_file)
		
	var size = texture.get_size()
	target_width = DOCUMENT_WIDTH
	target_height = (size.y / size.x) * DOCUMENT_WIDTH 
			
	get_node("TextureRect").texture = texture
	get_node("TextureRect").set_scale(Vector2(target_width/size.x, target_height/size.y))
	get_node("Camera2D").position.y = HEIGHT / 2
	


func _input(event):	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		_move_cursor(event.position.x, event.position.y)		
	elif event.is_action_pressed("ui_cancel"):
		global.go_to_browser_scene()
	elif event.is_action_pressed("ui_left"):
		change_selected_label(-1)
	elif event.is_action_pressed("ui_right"):
		change_selected_label(1)
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.scancode == KEY_BACKSPACE:
			_on_backspace_pressed()		
		else:			
			_on_letter_pressed(char(event.unicode))
		update_cursor_position()
		
func _on_letter_pressed(l):
	current_label.set_text(current_label.get_text() + l)
	
func _on_backspace_pressed():
	var size = len(current_label.get_text())
	if size > 0:
		current_label.set_text(current_label.get_text().substr(0, size - 1))
	
func change_selected_label(inc):
	if len(labels) > 1:
		#Delete current label if empty
		if current_label.get_text() == "":
			labels.remove(current_label_num)
			remove_child(current_label)
			if inc == 1:
				current_label_num -= 1
			
		#Select new current_label_num
		current_label_num += inc
		if current_label_num == -1:
			current_label_num = len(labels) -1
		elif current_label_num == len(labels):
			current_label_num = 0

		#Select new current_label
		current_label.unselect()		
		current_label = labels[current_label_num]
		current_label.select()
		current_color = current_label.color
		current_font = current_label.size
		update_color_and_size()
		
		update_cursor_position()
	
func _process(delta):	
	if Input.is_action_pressed("ui_up") or get_node("CanvasLayer/Panel/VBoxContainer/ButtonUp").is_pressed():
		_move_camera_up(delta)
	elif Input.is_action_pressed("ui_down") or get_node("CanvasLayer/Panel/VBoxContainer/ButtonDown").is_pressed():
		_move_camera_down(delta)	
    
func _move_camera_up(delta):
	get_node("Camera2D").position.y = clamp(get_node("Camera2D").position.y - delta * CAMERA_SPEED, HEIGHT / 2, target_height - HEIGHT / 2)

func _move_camera_down(delta):	
	get_node("Camera2D").position.y = clamp(get_node("Camera2D").position.y + delta * CAMERA_SPEED, HEIGHT / 2, target_height - HEIGHT / 2)
	
	
func _create_label():
	var label = label_scene.instance()
	labels.append(label)
	add_child(label)
	current_label = label	
	current_label_num = len(labels) -1
	update_color_and_size()
		
func update_color_and_size():
	if current_color == COLOR_BLACK:
		go_black()
	elif current_color == COLOR_BLUE:
		go_blue()
	elif current_color == COLOR_RED:
		go_red()
		
	if current_font == FONT_SMALL:
		go_small()
	elif current_font == FONT_MEDIUM:
		go_medium()
	elif current_font == FONT_BIG:
		go_big()
	
func _move_cursor(x, y):
	if x > 110 :		
		if current_label == null or current_label.get_text() != "":
			if current_label != null:
				current_label.unselect()
			_create_label()
		
		var camera_adjust = get_node("Camera2D").position.y - HEIGHT / 2
		cursor.position.x = x
		cursor.position.y = y - (cursor.height / 2) + camera_adjust
		
		current_label.position.x = cursor.position.x
		current_label.position.y = cursor.position.y
		
			
	
func update_cursor_position():
	cursor.position.x = current_label.position.x + current_label.font.get_string_size(current_label.get_text()).x
	cursor.position.y = current_label.position.y
	
func go_black():
	current_label.go_black()
	cursor.go_black()
	current_color = COLOR_BLACK
	
	
func go_blue():
	current_label.go_blue()
	cursor.go_blue()
	current_color = COLOR_BLUE
	
func go_red():
	current_label.go_red()
	cursor.go_red()
	current_color = COLOR_RED
	
func go_small():	
	current_label.go_small()
	cursor.go_small()
	# center
	if current_font == FONT_MEDIUM:
		current_label.position.y += 20
	elif current_font == FONT_BIG:
		current_label.position.y += 55
	update_cursor_position()
	current_font = FONT_SMALL
	
func go_medium():
	current_label.go_medium()
	cursor.go_medium()
	if current_font == FONT_SMALL:
		current_label.position.y -= 20
	elif current_font == FONT_BIG:
		current_label.position.y += 35
	update_cursor_position()
	current_font = FONT_MEDIUM
	
func go_big():
	current_label.go_big()
	cursor.go_big()
	if current_font == FONT_SMALL:
		current_label.position.y -= 55
	elif current_font == FONT_MEDIUM:
		current_label.position.y -= 35
	update_cursor_position()
	current_font = FONT_BIG

func _on_ButtonBlack_pressed():
	go_black()


func _on_ButtonBlue_pressed():
	go_blue()


func _on_ButtonRed_pressed():
	go_red()


func _on_ButtonSmall_pressed():
	go_small()


func _on_ButtonMedium_pressed():
	go_medium()


func _on_ButtonBig_pressed():
	go_big()
