extends Node

signal pause

func _process(delta):
	# just pause the game really
	if Input.is_action_just_pressed("menu"):
		emit_signal("pause")
		get_tree().set_deferred("paused", !get_tree().paused)
