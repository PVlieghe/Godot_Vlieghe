class_name World extends Node3D

@onready var labelQuest:Label = $Label
@onready var label2:Label = $Label2
@export var key:String


var time_left = 5.0
var fade_duration = 1.0
var fade_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	fade_timer = fade_duration
	label2.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_left -= delta 
	if time_left <=0:
		fade_timer -= delta
		if fade_timer == 0:
			labelQuest.queue_free()
		else:
			labelQuest.modulate.a = fade_timer / fade_duration


func _on_area_3d_body_entered(body):
	if body.get_collision_layer_value(4):
		label2.visible=true
