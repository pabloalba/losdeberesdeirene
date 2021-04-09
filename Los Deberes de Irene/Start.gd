extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	
	var dir = Directory.new()
	if dir.open(global.START_PATH) == OK:
		get_node("Label").text = dir.get_current_dir ()
	#var dir = Directory.new()
	#dir.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	#dir.make_dir("deberes")


func _input(event):	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		global.go_to_browser_scene()
