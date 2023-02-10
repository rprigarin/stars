extends KinematicBody2D

export var transition_time = 2.25
export var warning_time = 1.5
export var initiator = false # if true, starts the game when collected
onready var variant = 2
onready var is_suspended = false
var normal_sprite
var expiration_sprite
var final_sprite
var suspended_sprite
signal spawn_enemy

func _ready():
	normal_sprite = load("res://assets/star1.png")
	expiration_sprite  = load("res://assets/mutating_star1.png")
	final_sprite  = load("res://assets/final_star1.png")
	suspended_sprite  = load("res://assets/pulled_star1.png")
	connect("spawn_enemy",get_node("/root/map/Generator"),"_on_Star_spawn_enemy")
	
	# make sure the initiator star doesn't expire
	if(!initiator):
		get_node("Timer").start(transition_time)

func _on_Timer_timeout():
	if(variant <= 1):
		get_node("Timer").start(transition_time)
		get_node("StarTexture").texture = normal_sprite
		is_suspended = false
		variant += 1
		return
	if(variant == 2):
		get_node("Timer").start(transition_time)
		get_node("StarTexture").texture = expiration_sprite
		variant += 1
		return
	if(variant == 3):
		# disable collision
		get_node("collision").disabled = true
		get_node("area1").monitorable = false
		get_node("Timer").start(warning_time)
		# turn star red
		get_node("StarTexture").texture = final_sprite
		variant += 1
		return
	if(variant >= 4):
		emit_signal("spawn_enemy", position, self)

func suspend():
	# only suspend if the star is not fully mutated
	if(variant < 4):
		get_node("StarTexture").texture = suspended_sprite
		variant = 1
		is_suspended = true
		get_node("Timer").start(transition_time)

func is_star_suspended():
	return is_suspended

func is_initiator():
	return initiator

func _on_Player_start_game() -> void:
	if(initiator):
		print("starting the bloody game")
		get_parent().get_node("Timer").start()
