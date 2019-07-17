extends Node2D

const WIDTH = 1105
const HEIGHT = 630
const ITEM_WIDTH = 430
const ITEM_HEIGHT = 430


var num_rows = 1
var num_columns = 1
var items = []
var scale_childs = 1
var current_page = 0
var max_pages


# Called when the node enters the scene tree for the first time.
func _ready():
	items = []
	
	
func resize_grid():
	# Resize grid
	if len(items) == 1:
		num_rows = 1
		num_columns = 1
		scale_childs = 1
	elif len(items) == 2:
		num_rows = 1
		num_columns = 2
		scale_childs = 1
	elif len(items) == 3:
		num_rows = 1
		num_columns = 3
		scale_childs = 0.7
	elif len(items) == 4:
		num_rows = 2
		num_columns = 2
		scale_childs = 0.7
	elif len(items) == 5:
		num_rows = 2
		num_columns = 3
		scale_childs = 0.7
	elif len(items) >= 6:
		num_rows = 2
		num_columns = 3
		scale_childs = 0.7	
	move_items()
	
func clear():
	for i in range(0, get_child_count()):
    	get_child(i).queue_free()
	items = []
	current_page = 0

func add_item(item):
	items.append(item)
	max_pages = len(items) / (global.MAX_ITEMS_BY_PAGE)
	add_child(item)
	resize_grid()
	
func move_items():
	
	for item in items:
		item.visible = false
	
	var current_row = 0
	var current_column = 0
	var current_item = 0
	if len(items) > global.MAX_ITEMS_BY_PAGE:
		current_item = global.MAX_ITEMS_BY_PAGE * current_page
	
	var width_item = ITEM_WIDTH * scale_childs
	var inc_x = (WIDTH - (width_item * num_columns)) / (num_columns + 1)
	
	var height_item = ITEM_HEIGHT * scale_childs
	var inc_y = (HEIGHT - (height_item * num_rows)) / (num_rows + 1)
	
	
	while current_row < num_rows:
		current_column = 0
		while current_column < num_columns:
			if current_item < len(items):				
				items[current_item].set_scale(Vector2(scale_childs, scale_childs))
				items[current_item].position.x = inc_x  + ((width_item + inc_x) * current_column)
				items[current_item].position.y = inc_y  + ((height_item + inc_y) * current_row)
				items[current_item].visible = true
				current_item += 1
			current_column += 1
		current_row += 1
			
	
func next_page():
	if current_page < max_pages:
		current_page += 1
		move_items()
		
func previous_page():
	if current_page > 0:
		current_page -= 1
		move_items()