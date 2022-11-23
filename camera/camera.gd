extends Camera2D

@onready var target = %Player

func _physics_process(delta):
	if target:
		global_position = target.global_position



