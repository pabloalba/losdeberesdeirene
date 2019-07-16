extends Node2D


signal item_selected
var text = ""
var bg_file = preload("res://assets/item_file_bg.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(txt, texture):
	text = txt
	get_node("VBoxContainer/Label").text = text
	get_node("VBoxContainer//TextureRect").texture = texture



func _on_Button_pressed():
	emit_signal("item_selected", text)


func _on_VBoxContainer_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.pressed:
				emit_signal("item_selected", text)

func set_is_file(is_file):
	if is_file:
		get_node("TextureRect").texture = bg_file
