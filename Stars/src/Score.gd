extends Label

export var current_score = 0

func _ready():
	pass

func increment_score():
	current_score += 1

func reset_score():
	current_score = 0

func _process(_delta):
	text = str(current_score)
