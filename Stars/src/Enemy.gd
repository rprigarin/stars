extends KinematicBody2D

export var speed = 100
var screen_size
var direction = Vector2.ZERO

func _ready():
	if(get_node("/root/map/Player")):
		direction = (get_node("/root/map/Player").position - position).normalized()
		look_at(get_node("/root/map/Player").position)
	else:
		queue_free()
	screen_size = get_viewport_rect().size
		
func _process(_delta):
	move_and_slide(direction * speed)
	# delete enemy if it moves out of the screen
	if((position.x < -32 or position.x > screen_size.x+32)
	 or (position.y < -32 or position.y > screen_size.y+32)):
		queue_free()
