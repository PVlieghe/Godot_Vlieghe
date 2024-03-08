class_name SaveManager extends Node

const default_filename:String = "save_file"

func _build():
	return {
		"position_x": GameState.player.position.x,
		"position_y": GameState.player.position.y,
		"position_z": GameState.player.position.z,
	}

func save_game():
		var savegame = FileAccess.open(default_filename, FileAccess.WRITE)
		if (savegame != null):
			savegame.store_line(JSON.stringify(_build()))

func load_game():
	var savegame = FileAccess.open(default_filename, FileAccess.READ)
	if (savegame != null): 
		var json:JSON = JSON.new()
		var parse_result = json.parse(savegame.get_line())
		if not (parse_result == OK): 
			return
		var data: Dictionary = json.get_data()
		GameState.player.position.x = data.get("position_x", GameState.player.position.x)
		GameState.player.position.y = data.get("position_y", GameState.player.position.y)
		GameState.player.position.z = data.get("position_z", GameState.player.position.z)
