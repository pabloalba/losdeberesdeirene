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
	get_node("BGPage/BtnPrevPage").visible = false
	get_node("BGPage/BtnNextPage").visible = len(files) > global.MAX_ITEMS_BY_PAGE
	grid.clear()	
	for file in files:
		add_item(file, scale)
	if global.current_path == global.START_PATH:
		get_node("BGPage").visible = false
	else:
		get_node("BGPage").visible = true
	
	
func add_item(text, scale):
	var texture	
	var is_file = false
	if text.ends_with("jpg"):
		texture = global.load_jpg(global.current_path+"/"+text)
		is_file = true
	elif text.ends_with("png"):
		texture = global.load_png(global.current_path+"/"+text)
		is_file = true
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
		item.init(text, texture)
		item.connect("item_selected", self, "_item_selected")		
		grid.add_item(item)

func _item_selected(name):
	# Is it a directory?
	var dir = Directory.new()
	if dir.open(global.current_path + "/" + name) == OK:
		global.current_path = global.current_path+"/"+name
		load_content()
	else:
		global.current_file = global.current_path + "/" + name
		global.go_to_writer_scene()
	
func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".lddi")  and file != "icon.png":
			files.append(file)
			
	dir.list_dir_end()
	files.sort()
	return files


func _input(event):
	if event.is_action_pressed("ui_left"):
		grid.previous_page()
	if event.is_action_pressed("ui_right"):
		grid.next_page()
	if event.is_action_pressed("ui_back"):
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
	get_node("BGPage/BtnPrevPage").visible = grid.current_page > 0
	get_node("BGPage/BtnNextPage").visible = grid.current_page < grid.max_pages


func _on_BtnPrevPage_pressed():
	grid.previous_page()
	get_node("BGPage/BtnPrevPage").visible = grid.current_page > 0
	get_node("BGPage/BtnNextPage").visible = grid.current_page < grid.max_pages
