extends Node

export var max_spawns = 2
export var increase_cap = 6
export var difficulty_cap = 12
export var timer_max_cap = 0.6
export var timer_min_cap = -0.5
var star
var enemy
var rng = RandomNumberGenerator.new()
onready var difficulty = 0
onready var is_player_dead = false
signal difficulty_increase

func _ready():
	rng.randomize()

func add_star():
	star = preload("res://src/Star.tscn").instance()
	star.set_position(Vector2(rng.randf_range(30.0, 1000.0),rng.randf_range(50.0, 550.0)))
	add_child(star)

func _on_Timer_timeout():
	call_deferred("add_star")
	for _i in range(difficulty % max_spawns):
		call_deferred("add_star")
	get_node("Timer").wait_time = 2 + rng.randf_range(timer_min_cap, timer_max_cap)
	
	if(!is_player_dead):
		difficulty += 1
	
		if(difficulty == difficulty_cap):
			max_spawns += 1
			difficulty = 0
			difficulty_cap = difficulty_cap + increase_cap
			increase_cap += 1
			if(timer_max_cap >= 0):
				timer_max_cap -= 0.05
			emit_signal("difficulty_increase")

func _on_Star_spawn_enemy(p, n):
	enemy  = preload("res://src/Enemy.tscn").instance()
	enemy.position = p
	add_child(enemy)
	n.queue_free()

func _on_Player_player_died():
	is_player_dead = true
