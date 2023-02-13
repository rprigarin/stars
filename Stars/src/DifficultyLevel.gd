extends Label

onready var difficulty_level = 0

# indicate level 1 (start of game)
func _on_Player_start_game() -> void:
	difficulty_level += 1

# indicate increase in difficulty
func _on_Generator_difficulty_increase():
	difficulty_level += 1

func _process(_delta):
	text = "Level: " + str(difficulty_level)
