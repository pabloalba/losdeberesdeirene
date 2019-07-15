extends Node2D

const DOCUMENT_WIDTH = 1265
const HEIGHT = 768
const CAMERA_SPEED = 1000

var target_width
var target_height

func _ready():
	load_docuemnt()
	set_process_input(true)
	
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
	if event.is_action_pressed("ui_back"):
		global.go_to_browser_scene()
	
func _process(delta):	
	if Input.is_action_pressed("ui_up") or get_node("CanvasLayer/Panel/VBoxContainer/ButtonUp").is_pressed():
		_move_camera_up(delta)
	elif Input.is_action_pressed("ui_down") or get_node("CanvasLayer/Panel/VBoxContainer/ButtonDown").is_pressed():
		_move_camera_down(delta)	
    
func _move_camera_up(delta):
	get_node("Camera2D").position.y = clamp(get_node("Camera2D").position.y - delta * CAMERA_SPEED, HEIGHT / 2, target_height - HEIGHT / 2)

func _move_camera_down(delta):	
	get_node("Camera2D").position.y = clamp(get_node("Camera2D").position.y + delta * CAMERA_SPEED, HEIGHT / 2, target_height - HEIGHT / 2)