extends KinematicBody2D

export var original_speed = 400
export var suspension_cap = 3
export var speed_boost_multiplier = 1.5
var screen_size
var score
var normal_sprite
var boost_sprite
var suspension_area
var suspension_counter : int
var suspension_bar
var suspension_bar_sprite0
var suspension_bar_sprite1
var suspension_bar_sprite2
var suspension_bar_sprite3
onready var speed = original_speed
onready var is_boosted = false
onready var is_dead = false
onready var suspension_available = false
onready var boosted_speed = original_speed * speed_boost_multiplier
signal star_eaten
signal ate_ten_stars
#signal ate_thirty_stars
signal player_died
signal start_game

func _ready():
	score = preload("res://src/Score.tscn").instance()
	normal_sprite = load("res://assets/player1.png")
	boost_sprite = load("res://assets/player1_boosted.png")
	suspension_bar_sprite0 = load("res://assets/suspension_bar_0.png")
	suspension_bar_sprite1 = load("res://assets/suspension_bar_1.png")
	suspension_bar_sprite2 = load("res://assets/suspension_bar_2.png")
	suspension_bar_sprite3 = load("res://assets/suspension_bar_3.png")
	add_child(score)
	connect("star_eaten",get_node("/root/map/Bg/ActualScore"),"increase_score")
	connect("ate_ten_stars",get_node("/root/map/Bg/ActualScore"),"increase_score")
	screen_size = get_viewport_rect().size
	suspension_area = get_node("area2")
	suspension_bar = get_node("SuspensionBar")

func _process(delta):
	
	# movement
	if(!is_dead):
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		
		if Input.is_action_pressed("suspend"):
			if(suspension_available):
				for i in suspension_area.get_overlapping_areas():
					if(i.is_in_group("star")):
						i.get_parent().call("suspend")
				suspension_available = false
				suspension_counter = 0
				get_node("SuspensionField").hide()
				suspension_bar.texture = suspension_bar_sprite0
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed

		position += velocity * delta
		position.x = clamp(position.x, 32, screen_size.x-32)
		position.y = clamp(position.y, 32, screen_size.y-32)

func _on_area1_area_entered(area):
	if(!is_dead):
		if(area.is_in_group("enemy")):
			is_dead = true
			emit_signal("player_died")
			hide()
	
		if(area.is_in_group("star")):
			if(!area.get_parent().call("is_star_suspended")):
				# increment score
				score.increment_score()
					
				# eat star
				if(area.get_parent().call("is_initiator")):
					emit_signal("start_game")
				area.get_parent().queue_free()
				
				# signal that the star has been eaten
				if(score.current_score >= 10):
					get_node("PlayerTexture").texture = boost_sprite
					speed = boosted_speed
					score.reset_score()
					emit_signal("ate_ten_stars",25)
					get_node("SuperTimer").start(3)
					is_boosted = true
					
					# suspension powerup management
					if(!suspension_available):
						suspension_counter += 1
						if(suspension_counter >= suspension_cap):
							if(!suspension_available):
								suspension_available = true
								get_node("SuspensionField").visible = true
					
						match(suspension_counter):
							1:
								suspension_bar.texture = suspension_bar_sprite1
							2:
								suspension_bar.texture = suspension_bar_sprite2
							3:
								suspension_bar.texture = suspension_bar_sprite3
							_:
								suspension_bar.texture = suspension_bar_sprite0
					
				emit_signal("star_eaten", 10)

func _on_SuperTimer_timeout():
	get_node("PlayerTexture").texture = normal_sprite
	speed = original_speed
	is_boosted = false
