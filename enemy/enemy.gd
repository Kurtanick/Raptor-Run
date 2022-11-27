extends CharacterBody2D

@export var movement_speed = 50

@onready var sprite = $AnimatedSprite2D

var active  = false
var gravity = 1600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if not active:
		return
	
	velocity.x = -movement_speed
	velocity.y += gravity * delta
	move_and_slide()
	
func set_active(value):
	active = value
	if active:
		sprite.play("walk")
