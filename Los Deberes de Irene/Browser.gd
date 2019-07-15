extends Node2D

var item_scene = preload("res://Item.tscn")
var grid
var current_path = "user://"

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node("CenterContainer/Grid")
	current_path = "user://"
	load_content()
	set_process_input(true)
	
func load_content():	
	var files = _list_files_in_directory(current_path)
		
	grid.clear()	
	for file in files:
		add_item(file, scale)
	
	
func add_item(text, scale):
	var texture	
	if text.ends_with("jpg"):
		texture = load_jpg(current_path+"/"+text)
	elif text.ends_with("png"):
		texture = load_png(current_path+"/"+text)
	else:
		# Is it a directory
		var dir = Directory.new()
		if dir.open(current_path+"/"+text) == OK:
			texture = load_png(current_path+"/"+text+"/icon.png")
			if texture == null:
				texture = load_png("res://assets/cuaderno.png")
				
	if texture != null:
		var item = item_scene.instance()
		item.init(text, texture)
		item.connect("item_selected", self, "_item_selected")		
		grid.add_item(item)

func _item_selected(name):
	# Is it a directory?
	var dir = Directory.new()
	if dir.open(current_path+"/"+name) == OK:
		current_path = current_path+"/"+name
		load_content()
	else:
		print("File")
	
func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file != "icon.png":
			files.append(file)
			
	dir.list_dir_end()
	files.sort()
	return files
	
func load_jpg(file):
	var jpg_file = File.new()
	if jpg_file.file_exists(file):
		jpg_file.open(file, File.READ)
		var bytes = jpg_file.get_buffer(jpg_file.get_len())
		var img = Image.new()
		var data = img.load_jpg_from_buffer(bytes)
		var imgtex = ImageTexture.new()
		imgtex.create_from_image(img)
		jpg_file.close()
		return imgtex


func load_png(file):
	var png_file = File.new()
	if png_file.file_exists(file):
		png_file.open(file, File.READ)
		var bytes = png_file.get_buffer(png_file.get_len())
		var img = Image.new()
		var data = img.load_png_from_buffer(bytes)
		var imgtex = ImageTexture.new()
		imgtex.create_from_image(img)
		png_file.close()
		return imgtex

func _input(event):
	if event.is_action_pressed("ui_left"):
		grid.previous_page()
	if event.is_action_pressed("ui_right"):
		grid.next_page()
	if event.is_action_pressed("ui_back"):
		var pos = current_path.find_last("/")
		if pos > 6:
			current_path = current_path.substr(0, pos)
			load_content()
    
	
