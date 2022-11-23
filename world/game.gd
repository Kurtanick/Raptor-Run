extends Node2D

@export var world_speed = 300
@export var min_platform_x = 450
@export var max_platform_x = 550
@export var min_platform_y = -150
@export var max_platform_y = 150

@onready var moving_environment = $Environment/Moving

var platform = preload("res://world/platform.tscn")
var rng = RandomNumberGenerator.new()
var last_platform_position = Vector2.ZERO
var next_spawn_time = 0

func _ready():
	rng.randomize()
	
func _process(delta):
	if Time.get_ticks_msec() > next_spawn_time:
		spawn_next_platform()

func _physics_process(delta):
	#move platforms
	moving_environment.position.x -= world_speed * delta
	
func spawn_next_platform():
	var new_platorm = platform.instantiate()
	
	if last_platform_position == Vector2.ZERO:
		new_platorm.position = Vector2(400, 0)
		
	else:
		var x = last_platform_position.x + rng.randi_range(min_platform_x,max_platform_x)
		var y = clamp(last_platform_position.y  + rng.randi_range(min_platform_y,max_platform_y),200,1000)
		new_platorm.position = Vector2(x, y)
		
	moving_environment.add_child(new_platorm)
	
	last_platform_position = new_platorm.position
	next_spawn_time += world_speed
