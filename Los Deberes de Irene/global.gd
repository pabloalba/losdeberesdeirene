extends Node

const LABEL_CURSOR_FIX = 1

var current_path = "user://"
var current_file


	
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
	