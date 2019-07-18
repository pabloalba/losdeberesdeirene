extends Node

const LABEL_CURSOR_FIX = 1
const MAX_ITEMS_BY_PAGE = 6

const RED = 0
const BLUE = 1
const BLACK = 2
const SMALL = 24
const MEDIUM = 48
const BIG = 96

const START_PATH = "user://"

var current_path = START_PATH
var current_file
const label_scene = preload("res://LabelCustomizable.tscn")


	
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
		
func go_to_writer_scene():
	get_tree().change_scene("res://Writer.tscn")
	
func go_to_browser_scene():
	get_tree().change_scene("res://Browser.tscn")
	

func save_labels(labels):
	var labels_data = generate_labels_data(labels)
	if len(labels_data) > 0:
		var save_file = File.new()
		if save_file.open(global.current_file + ".lddi", File.WRITE) == OK: # If the opening of the save file returns OK	
			save_file.store_var(labels_data) # then we store the contents of the var save inside it
			save_file.close() # and we gracefully close the file :)

func load_labels():
	var labels = []
	
	var save_file = File.new() # We initialize the File class
	if save_file.open(global.current_file + ".lddi", File.READ_WRITE) == OK: # If the opening of the save file returns OK
		var labels_data # we create a temporary var to hold the contents of the save file
		labels_data = save_file.get_var() # we get the contents of the save file and store it on TEMP_D
		save_file.close()
		labels = process_labels_data(labels_data)		
		
	return labels
	
func process_labels_data(labels_data):	
	var labels = []
	for data in labels_data:
		var label = label_scene.instance()
		label.from_serialization(data)
		labels.append(label)
	return labels
		
	
func generate_labels_data(labels):
	var labels_data = []
	for label in labels:	
		if label.get_text() != "":	
			labels_data.append(label.serialize())
	return labels_data
	