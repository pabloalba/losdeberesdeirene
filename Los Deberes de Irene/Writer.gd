extends Node2D

const DOCUMENT_WIDTH = 1265
const HEIGHT = 768
const CAMERA_SPEED = 1000


var target_width
var target_height
var cursor
var labels
var current_label
var current_label_num
var current_color = global.BLACK
var current_font = global.MEDIUM
var label_scene = preload("res://LabelCustomizable.tscn")


func _ready():
	load_document()
	set_process_input(true)
	cursor = get_node("Cursor")
	cursor.set_as_toplevel(true)
	labels = global.load_labels()
	if len(labels) > 0:
		for label in labels:
			add_child(label)
		select_label_by_num(0)		
	else:				
		_move_cursor(200, 200)
		update_cursor_position()
		go_blue()
		go_medium()
	
func _label_selected(label):
	var num = 0
	for l in labels:
		if l == label:
			select_label_by_num(num)
			break
		num += 1	
	
func select_label_by_num(num):
	var old_label = current_label
	var old_label_num = current_label_num
	
	current_label = labels[num]
	if old_label != current_label:
		current_label_num = num
		current_color = current_label.color
		current_font = current_label.size
		current_label.select()
		update_color_and_size()	
		update_cursor_position()
				
		if old_label != null:			
			old_label.unselect()	
			
			#Delete current label if empty
			if old_label.get_text() == "":
				labels.erase(old_label)
				remove_child(old_label)
				if current_label_num >= old_label_num:
					current_label_num -= 1
			
		
func load_document():
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
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and event.position.x > 110:
		_click(event.position.x, event.position.y)	
	elif event.is_action_pressed("ui_up") or event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP:	
		_move_camera_up(0.05)
	elif event.is_action_pressed("ui_down") or event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN:	
		_move_camera_down(0.05)
	elif event.is_action_pressed("ui_cancel"):
		global.go_to_browser_scene()
	elif event.is_action_pressed("ui_focus_prev"):
		change_selected_label(-1)
	elif event.is_action_pressed("ui_focus_next"):
		change_selected_label(1)
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.scancode == KEY_BACKSPACE:
			_on_backspace_pressed()		
		else:			
			_on_letter_pressed(char(event.unicode))
		update_cursor_position()
		
func _on_letter_pressed(l):
	current_label.set_text(current_label.get_text() + l)
	global.save_labels(labels)
	
func _on_backspace_pressed():
	var size = len(current_label.get_text())
	if size > 0:
		current_label.set_text(current_label.get_text().substr(0, size - 1))
		global.save_labels(labels)
	
func change_selected_label(inc):
	if len(labels) > 1:
		#Select new current_label_num
		var num = current_label_num +inc
		if num == -1:
			num = len(labels) -1
		elif num == len(labels):
			num = 0
		
		select_label_by_num(num)		
		global.save_labels(labels)
	
func _process(delta):	
	if Input.is_action_pressed("ui_up"):
		_move_camera_up(delta)
	elif Input.is_action_pressed("ui_down"):
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
	if current_color == global.BLACK:
		go_black()
	elif current_color == global.BLUE:
		go_blue()
	elif current_color == global.RED:
		go_red()
		
	if current_font == global.SMALL:
		go_small()
	elif current_font == global.MEDIUM:
		go_medium()
	elif current_font == global.BIG:
		go_big()
	
func _click(x, y):
	var camera_adjust = get_node("Camera2D").position.y - HEIGHT / 2	
	y = y + camera_adjust
	var clicked_label
	for label in labels:
		if label.position.x < x and x < label.position.x + label.get_width() and \
			label.position.y < y and y < label.position.y + label.size:
				clicked_label = label
				break
	if clicked_label == null:
		_move_cursor(x, y)
	else:
		_label_selected(clicked_label)
	
	
func _move_cursor(x, y):
	if current_label == null or current_label.get_text() != "":
		if current_label != null:
			current_label.unselect()
		_create_label()
	
	
	cursor.position.x = x
	cursor.position.y = y - (cursor.height / 2) 
	
	current_label.position.x = cursor.position.x
	current_label.position.y = cursor.position.y
	global.save_labels(labels)
		
			
	
func update_cursor_position():
	cursor.position.x = current_label.position.x + current_label.get_width()
	cursor.position.y = current_label.position.y
	
func go_black():
	current_label.go_black()
	cursor.go_black()
	current_color = global.BLACK
	global.save_labels(labels)
	get_node("CanvasLayer/Panel/ButtonBlack").pressed = true
	get_node("CanvasLayer/Panel/ButtonBlue").pressed = false
	get_node("CanvasLayer/Panel/ButtonRed").pressed = false
	
	
func go_blue():
	current_label.go_blue()
	cursor.go_blue()
	current_color = global.BLUE
	global.save_labels(labels)
	get_node("CanvasLayer/Panel/ButtonBlack").pressed = false
	get_node("CanvasLayer/Panel/ButtonBlue").pressed = true
	get_node("CanvasLayer/Panel/ButtonRed").pressed = false
	
func go_red():
	current_label.go_red()
	cursor.go_red()
	current_color = global.RED
	global.save_labels(labels)
	get_node("CanvasLayer/Panel/ButtonBlack").pressed = false
	get_node("CanvasLayer/Panel/ButtonBlue").pressed = false
	get_node("CanvasLayer/Panel/ButtonRed").pressed = true
	
func go_small():	
	current_label.go_small()
	cursor.go_small()
	# center
	if current_font == global.MEDIUM:
		current_label.position.y += 5
	elif current_font == global.BIG:
		current_label.position.y += 10
	update_cursor_position()
	current_font = global.SMALL
	get_node("CanvasLayer/Panel/ButtonSmall").pressed = true
	get_node("CanvasLayer/Panel/ButtonMedium").pressed = false
	get_node("CanvasLayer/Panel/ButtonBig").pressed = false
	global.save_labels(labels)
	
	
func go_medium():
	current_label.go_medium()
	cursor.go_medium()
	if current_font == global.SMALL:
		current_label.position.y -= 5
	elif current_font == global.BIG:
		current_label.position.y += 5
	update_cursor_position()
	current_font = global.MEDIUM
	get_node("CanvasLayer/Panel/ButtonSmall").pressed = false
	get_node("CanvasLayer/Panel/ButtonMedium").pressed = true
	get_node("CanvasLayer/Panel/ButtonBig").pressed = false
	global.save_labels(labels)
	
func go_big():
	current_label.go_big()
	cursor.go_big()
	if current_font == global.SMALL:
		current_label.position.y -= 10
	elif current_font == global.MEDIUM:
		current_label.position.y -= 5
	update_cursor_position()
	current_font = global.BIG
	get_node("CanvasLayer/Panel/ButtonSmall").pressed = false
	get_node("CanvasLayer/Panel/ButtonMedium").pressed = false
	get_node("CanvasLayer/Panel/ButtonBig").pressed = true
	global.save_labels(labels)

func _on_ButtonBlack_pressed():
	go_black()


func _on_ButtonBlue_pressed():
	go_blue()


func _on_ButtonRed_pressed():
	go_red()



	

func _on_ButtonSmall_toggled(button_pressed):
	if button_pressed:
		go_small()


func _on_ButtonMedium_toggled(button_pressed):
	if button_pressed:
		go_medium()


func _on_ButtonBig_toggled(button_pressed):
	if button_pressed:
		go_big()


func _on_ButtonRed_toggled(button_pressed):
	if button_pressed:
		go_red()


func _on_ButtonBlue_toggled(button_pressed):
	if button_pressed:
		go_blue()


func _on_ButtonBlack_toggled(button_pressed):
	if button_pressed:
		go_black()


func _on_ButtonExit_pressed():
	global.go_to_browser_scene()
