extends Node2D

const RED = Color(255, 0, 0)
const BLUE = Color(0, 0, 255)
const BLACK = Color(0, 0, 0)
const SPEED = 0.5
var timer
var colorRect
var height = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	colorRect = get_node("ColorRect")
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.start(SPEED)

func _on_timer_timeout():	
		colorRect.visible = ! colorRect.visible
		timer.start(SPEED)
		
func go_black():
	colorRect.color = BLACK
	
func go_blue():
	colorRect.color = BLUE
	
func go_red():
	colorRect.color = RED
	
func go_small():
	colorRect.rect_size.x = 12
	colorRect.rect_size.y = 24
	height = 24
	
func go_medium():
	colorRect.rect_size.x = 24
	colorRect.rect_size.y = 48
	height = 48
	
func go_big():
	colorRect.rect_size.x = 48
	colorRect.rect_size.y = 96
	height = 96

