extends VBoxContainer


@onready var start_button = $StartButton
@onready var end_button = $EndButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	end_button.pressed.connect(_on_end_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world/main.tscn")

func _on_end_button_pressed():
	get_tree().quit()
