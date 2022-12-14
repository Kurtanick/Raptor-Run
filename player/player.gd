extends CharacterBody2D

signal player_died

@export var gravity = 1600
@export var jump_power = 600
@export var jumps_number = 3

@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound
@onready var shoot_sound = $ShootSound
@onready var enviornment = $"../Environment"
@onready var collision_shape = $CollisionShape2D
@onready var game = $"/root/World/"
@onready var projectile_position = $ProjectilePosition

var projectile = preload("res://projectile/projectile.tscn")
var active = true
var jumps_remaining = jumps_number
var was_jumping = false
var jump_pitch = 1.0
var ammo = 3

func _ready():
#	print("hello world")
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	velocity.y += gravity * delta;
	
	if active:
		#landing
		if was_jumping and is_on_floor():
			was_jumping = false
			jumps_remaining = jumps_number
			sprite.play("run")
			jump_pitch = 1.0
		
		#jumping
		if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
			jumps_remaining -= 1
			was_jumping = true
			velocity.y = - jump_power
			
			if jumps_remaining == 1:
				sprite.play("jump")
			else:
				sprite.play("doubleJump")
				
			jump_sound.set_pitch_scale(jump_pitch)
			jump_sound.play()
			jump_pitch += 0.2     
	
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("fire") and ammo > 0:
		var new_projectile = projectile.instantiate()
		new_projectile.position = projectile_position.global_position
		game.add_child(new_projectile)
		shoot_sound.play()
		sprite.play("shoot")
		ammo -= 1

func die():
	death_sound.play()
	sprite.play("death")
	active = false
	collision_shape.set_deferred("disabled", true)
	emit_signal("player_died")
	
func add_ammo(amount):
	ammo += amount

func _on_animation_finished():
	if sprite.animation == "shoot":
		sprite.play("run")
