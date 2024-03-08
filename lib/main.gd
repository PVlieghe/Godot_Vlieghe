extends Node3D

var save:SaveManager = SaveManager.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.player = $Player
	save.load_game()
	_enter_level("default", "world1", GameState.player.position == Vector3.ZERO)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass
func _enter_level(from:String, to:String, use_spawn_point:bool = true):
	if (GameState.current_level != null): GameState.current_level.queue_free()
	GameState.current_level = load("res://levels/" + to + ".tscn").instantiate()
	GameState.current_level_key = to
	add_child(GameState.current_level)
	if(use_spawn_point):
		for spawnpoint:SpawnPoint in GameState.current_level.find_children("", "SpawnPoint"):
			if(spawnpoint.key == from):
				GameState.player.position = spawnpoint.position
				GameState.player.rotation = spawnpoint.rotation




func _on_button_quit_pressed():
	save.save_game()
	get_tree().quit()
