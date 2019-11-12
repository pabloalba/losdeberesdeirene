extends Node2D

const RED = Color(255, 0, 0)
const BLUE = Color(0, 0, 255)
const BLACK = Color(0, 0, 0)
const SPEED = 0.5
var timer
var colorRect
var height = 36

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
	colorRect.rect_size.x = global.SMALL / 2
	colorRect.rect_size.y = global.SMALL
	height = global.SMALL
	
func go_medium():
	colorRect.rect_size.x = global.MEDIUM / 2
	colorRect.rect_size.y = global.MEDIUM
	height = global.MEDIUM
	
func go_big():
	colorRect.rect_size.x = global.BIG / 2
	colorRect.rect_size.y = global.BIG
	height = global.BIG

