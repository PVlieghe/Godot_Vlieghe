extends CharacterBody3D

@onready var camera:Camera3D = $Camera
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var lifeBar:Control = $Control
@onready var appleLabel:Label = $AppleLabel
@onready var actionLabel:Label = $ActionLabel
@onready var ray:RayCast3D = $Camera/RayCast3D

var lifepoint:float = 100
var appleNumber = 5

const ANIM_WALK = "player/running"
const ANIM_IDLE = "player/standing_idle"

const mouse_sensitivity:float = 0.002
const max_camera_angle_up:float = deg_to_rad(60)
const max_camera_angle_down:float = -deg_to_rad(75)
var mouse_captured:bool = false

const SPEED = 12
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	appleLabel.text = "Pommes restantes: "+ str(appleNumber)
	if mouse_captured:
		var joypad_dir: Vector2 = Input.get_vector("player_look_left", "player_look_right", "player_look_up", "player_look_down")
		if joypad_dir.length() > 0:
			var look_dir = joypad_dir * delta
			rotate_y(-look_dir.x * 2.0)
			camera.rotate_x(-look_dir.y)
			camera.rotation.x = clamp(camera.rotation.x - look_dir.y, max_camera_angle_down, max_camera_angle_up) 
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_right", "player_left", "player_backward", "player_forward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if(!mouse_captured): capture_mouse()
		anim.play(ANIM_WALK)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim.play(ANIM_IDLE)
	move_and_slide()
	
	#Ramassage de pommes
	if ray.is_colliding():
		var apple = ray.get_collider()
		actionLabel.text = "Ramasser une pomme: E"
		if Input.is_action_just_pressed("get_apple") and apple != null:
			apple.queue_free()
			appleNumber += 1
	else: 
		actionLabel.text = ""
	# gestion de la consommation de pommes
	if Input.is_action_just_pressed("eat_apple") and appleNumber > 0:
		appleNumber -= 1
		lifeBar.change_value(5)
	appleLabel.text = "Pommes restantes: "+ str(appleNumber)
		
	

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void: 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
func _ready():
	
	capture_mouse()
	anim.play(ANIM_IDLE)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and mouse_captured:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, max_camera_angle_down, max_camera_angle_up)
	if(event is InputEventKey) and Input.is_action_just_pressed("cancel"):
		release_mouse()

	


