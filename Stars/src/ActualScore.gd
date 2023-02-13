extends Label

onready var current_score = 0

func increase_score(i):
	current_score += i

func _process(_delta):
	text = str(current_score)
