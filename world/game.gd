extends Node2D

@export var world_speed = 300
@export var min_platform_x = 450
@export var max_platform_x = 550
@export var min_platform_y = -150
@export var max_platform_y = 150
@export var collectible_pitch_reset_interval = 2000

@onready var moving_environment = $Environment/Moving
@onready var collect_sound = $Sounds/CollectSound
@onready var score_lable = $HUD/UI/Score

var platform = preload("res://world/platform.tscn")
var platorm_collectible_single = preload("res://world/platform_collectible_single.tscn")
var platorm_collectible_row = preload("res://world/platform_collectible_row.tscn")
var platorm_collectible_raindow = preload("res://world/platform_collectible_rainbow.tscn")
var platorm_enemy = preload("res://world/platform_enemy.tscn")

var rng = RandomNumberGenerator.new()
var last_platform_position = Vector2.ZERO
var next_spawn_time = 0
var score = 0
var collectible_pitch = 1.0
var reset_collectible_pitch_time = 0

func _ready():
	rng.randomize()
	
func _process(delta):
	# Reset the collectible sound pitch after a time
	if Time.get_ticks_msec() > reset_collectible_pitch_time:
		collectible_pitch = 1.0
		
	if Time.get_ticks_msec() > next_spawn_time:
		spawn_next_platform()
		
	# Update the UI Lables
	score_lable.text = "Score: %s" %score

func _physics_process(delta):
	#move platforms
	moving_environment.position.x -= world_speed * delta
	
func spawn_next_platform():
	var avalible_platorms = [
		platform,
		platorm_collectible_single,
		platorm_collectible_row,
		platorm_collectible_raindow,
		platorm_enemy
	]
	
	var new_platorm = avalible_platorms.pick_random().instantiate()
	
	if last_platform_position == Vector2.ZERO:
		new_platorm.position = Vector2(400, 0)
		
	else:
		var x = last_platform_position.x + rng.randi_range(min_platform_x,max_platform_x)
		var y = clamp(last_platform_position.y  + rng.randi_range(min_platform_y,max_platform_y),200,1000)
		new_platorm.position = Vector2(x, y)
		
	moving_environment.add_child(new_platorm)
	
	last_platform_position = new_platorm.position
	next_spawn_time += world_speed

func add_score(value):
	score += value
	collect_sound.set_pitch_scale(collectible_pitch)
	collect_sound.play()
	collectible_pitch += 0.1
	reset_collectible_pitch_time = Time.get_ticks_msec() + collectible_pitch_reset_interval
