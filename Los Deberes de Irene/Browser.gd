extends Node2D

var item_scene = preload("res://Item.tscn")
var grid


# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node("CenterContainer/Grid")
	load_content()
	set_process_input(true)
	
func load_content():	
	set_title()
	var files = _list_files_in_directory(global.current_path)
	get_node("BtnPrevPage").visible = false
	get_node("BtnNextPage").visible = len(files) > global.MAX_ITEMS_BY_PAGE
	grid.clear()	
	if len(files) > 0:
		get_node("NoContent").visible = false
	else:
		get_node("NoContent").visible = true
	for file in files:
		add_item(file)
	if global.current_path == global.START_PATH:
		get_node("BGPage").visible = false
		if len(files) == 0:
			create_sample_directories()
	else:
		get_node("BGPage").visible = true
	
func create_sample_directories():
	var dir = Directory.new()
	dir.open(global.START_PATH)
	dir.make_dir("Lengua")
	dir.make_dir("Matemáticas")
	dir.copy("res://assets/lengua.png", "user://Lengua/icon.png")
	dir.copy("res://assets/matematicas.png", "user://Matemáticas/icon.png")
	load_content()
	
func add_item(text):
	var texture	
	var is_file = false
	var show_bookmark = false
	if text.ends_with("jpg") or text.ends_with("png"):
		is_file = true
		var save_file = File.new() # We initialize the File class
		if save_file.file_exists(global.current_path+"/"+text + ".lddi"):
			show_bookmark = true
		if text.ends_with("jpg"):
			texture = global.load_jpg(global.current_path+"/"+text)
		else:
			texture = global.load_png(global.current_path+"/"+text)
	else:
		# Is it a directory
		var dir = Directory.new()
		if dir.open(global.current_path+"/"+text) == OK:
			texture = global.load_png(global.current_path+"/"+text+"/icon.png")
			if texture == null:
				texture = load("res://assets/cuaderno.png")
				
	if texture != null:
		var item = item_scene.instance()
		item.set_is_file(is_file)
		item.show_bookmark(show_bookmark)
		item.init(text, texture)
		item.connect("item_selected", self, "_item_selected")		
		grid.add_item(item)

func _item_selected(item):
	var name = item.text
	item.select()
	yield(get_tree().create_timer(0.1), "timeout")
	# Is it a directory?	
	var dir = Directory.new()
	if dir.open(global.current_path + "/" + name) == OK:
		global.current_path = global.current_path+"/"+name
		load_content()
	else:
		global.current_file = global.current_path + "/" + name
		global.go_to_writer_scene()
	
func _list_files_in_directory(path):
	var directories = []
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".lddi")  and file != "icon.png":
			# Is it a directory
			var is_dir = Directory.new()
			if is_dir.open(path+"/"+file) == OK:	
				directories.append(file)
			else:			
				files.append(file)
	dir.list_dir_end()	
	directories.sort()
	files.sort()
	for f in files:
		directories.append(f)
	return directories


func _input(event):
	if event.is_action_pressed("ui_left"):
		grid.previous_page()
	if event.is_action_pressed("ui_right"):
		grid.next_page()
	if event.is_action_pressed("ui_back") or event.is_action_pressed("ui_cancel"):
		go_back()
    
	
func set_title():
	var title = ""
	var pos = global.current_path.find_last("/")
	if pos > 6:
		title = global.current_path.right(pos + 1)
	get_node("BGPage/LblTitle").text = title

func go_back():
	var pos = global.current_path.find_last("/")
	if pos > 6:
		global.current_path = global.current_path.substr(0, pos)
		load_content()


func _on_BtnBack_pressed():
	go_back()


func _on_BtnNextPage_pressed():
	grid.next_page()
	get_node("BtnPrevPage").visible = grid.current_page > 0
	get_node("BtnNextPage").visible = grid.current_page < grid.max_pages


func _on_BtnPrevPage_pressed():
	grid.previous_page()
	get_node("BtnPrevPage").visible = grid.current_page > 0
	get_node("BtnNextPage").visible = grid.current_page < grid.max_pages


func _on_BtnBack_button_down():
	get_node("BGPage/BtnBack/Label").rect_position.x += 8
	get_node("BGPage/BtnBack/Label").rect_position.y += 6


func _on_BtnBack_button_up():
	get_node("BGPage/BtnBack/Label").rect_position.x -= 8
	get_node("BGPage/BtnBack/Label").rect_position.y -= 6
