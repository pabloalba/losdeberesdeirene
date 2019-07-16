extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


func _input(event):	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		global.go_to_browser_scene()
