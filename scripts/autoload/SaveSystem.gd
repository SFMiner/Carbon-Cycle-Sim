extends Node

const SAVE_VERSION: String = "1.1"
const SAVE_KEY: String = "carbon_quest_save_data"

# Save data structure mirrors GDD Section 7
var save_data: Dictionary = {
	"version": SAVE_VERSION,
	"timestamp": "",
	"player": {
		"stages_unlocked": 1,
		"stages_completed": []
	},
	"settings": {
		"sfx_volume": 100,
		"music_volume": 80,
		"colorblind_mode": false,
		"tutorial_seen": [false, false, false]
	},
	"statistics": {
		"stage_1_best_time": 0.0,
		"stage_2_best_time": 0.0,
		"stage_3_best_time": 0.0,
		"total_reactions": 0
	}
}


func create_default_save() -> Dictionary:
	"""Creates a fresh save data dictionary with default values."""
	return {
		"version": SAVE_VERSION,
		"timestamp": Time.get_datetime_string_from_system(),
		"player": {
			"stages_unlocked": 1,
			"stages_completed": []
		},
		"settings": {
			"sfx_volume": 100,
			"music_volume": 80,
			"colorblind_mode": false,
			"tutorial_seen": [false, false, false]
		},
		"statistics": {
			"stage_1_best_time": 0.0,
			"stage_2_best_time": 0.0,
			"stage_3_best_time": 0.0,
			"total_reactions": 0
		}
	}


func update_from_game_manager() -> void:
	"""Syncs save_data with current GameManager state."""
	save_data["timestamp"] = Time.get_datetime_string_from_system()
	save_data["player"]["stages_unlocked"] = GameManager.current_stage
	save_data["player"]["stages_completed"] = GameManager.stages_completed.duplicate()
	save_data["statistics"]["total_reactions"] = GameManager.total_reactions

	# Update best times if better than previous
	if GameManager.is_stage_complete(1):
		var stage1_time: float = GameManager.get_stage1_completion_time()
		if save_data["statistics"]["stage_1_best_time"] == 0.0 or stage1_time < save_data["statistics"]["stage_1_best_time"]:
			save_data["statistics"]["stage_1_best_time"] = stage1_time

	if GameManager.is_stage_complete(2):
		var stage2_time: float = GameManager.get_stage2_completion_time()
		if save_data["statistics"]["stage_2_best_time"] == 0.0 or stage2_time < save_data["statistics"]["stage_2_best_time"]:
			save_data["statistics"]["stage_2_best_time"] = stage2_time

	if GameManager.is_stage_complete(3):
		var stage3_time: float = GameManager.balance_time
		if save_data["statistics"]["stage_3_best_time"] == 0.0 or stage3_time > save_data["statistics"]["stage_3_best_time"]:
			save_data["statistics"]["stage_3_best_time"] = stage3_time


func apply_to_game_manager() -> void:
	"""Loads save_data into GameManager state."""
	GameManager.current_stage = save_data["player"]["stages_unlocked"]
	GameManager.stages_completed = save_data["player"]["stages_completed"].duplicate()
	GameManager.total_reactions = save_data["statistics"]["total_reactions"]


func save_game() -> bool:
	"""Saves current game state to localStorage. Returns true on success."""
	# Update save data from current game state
	update_from_game_manager()

	# Convert dictionary to JSON string
	var json_string: String = JSON.stringify(save_data)

	# Handle web vs desktop
	if OS.has_feature("web"):
		# Use JavaScriptBridge for localStorage
		var result = JavaScriptBridge.eval("""
			try {
				localStorage.setItem('%s', '%s');
				true;
			} catch (e) {
				console.error('Save failed:', e);
				false;
			}
		""" % [SAVE_KEY, json_string.replace("'", "\\'")])
		return result if result != null else false
	else:
		# Use FileAccess for desktop
		var file = FileAccess.open("user://save_data.json", FileAccess.WRITE)
		if file:
			file.store_string(json_string)
			file.close()
			return true
		else:
			push_error("Failed to save file")
			return false


func load_game() -> bool:
	"""Loads game state from localStorage. Returns true if save exists and loaded successfully."""
	var json_string: String = ""

	# Handle web vs desktop
	if OS.has_feature("web"):
		# Use JavaScriptBridge for localStorage
		var result = JavaScriptBridge.eval("""
			try {
				localStorage.getItem('%s') || null;
			} catch (e) {
				console.error('Load failed:', e);
				null;
			}
		""" % [SAVE_KEY])

		if result == null:
			return false  # No save exists
		json_string = str(result)
	else:
		# Use FileAccess for desktop
		if not FileAccess.file_exists("user://save_data.json"):
			return false  # No save exists
		var file = FileAccess.open("user://save_data.json", FileAccess.READ)
		if file:
			json_string = file.get_as_text()
			file.close()
		else:
			return false

	# Parse JSON
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("Failed to parse save data JSON")
		return false

	var loaded_data: Dictionary = json.data

	# Check version and migrate if needed
	var loaded_version: String = loaded_data.get("version", "0.0")
	if loaded_version != SAVE_VERSION:
		loaded_data = migrate_save_data(loaded_data)

	# Apply loaded data
	save_data = loaded_data
	apply_to_game_manager()

	return true


func migrate_save_data(old_data: Dictionary) -> Dictionary:
	"""Migrates save data from old versions to current version."""
	var old_version: String = old_data.get("version", "0.0")
	var new_data: Dictionary = old_data.duplicate(true)

	match old_version:
		"0.0":
			# Very old or corrupted save - reset to defaults
			push_warning("Unrecognized save version, creating new save")
			return create_default_save()

		"1.0":
			# Migrate from v1.0 to v1.1: add colorblind_mode and tutorial_seen
			push_warning("Migrating save from v1.0 to v1.1")
			new_data["version"] = "1.1"

			if not new_data.get("settings", {}).has("colorblind_mode"):
				new_data["settings"]["colorblind_mode"] = false

			if not new_data.get("settings", {}).has("tutorial_seen"):
				new_data["settings"]["tutorial_seen"] = [false, false, false]

			return new_data

		"1.1":
			# Current version, no migration needed
			return new_data

		_:
			# Unrecognized version
			push_warning("Unrecognized save version: " + old_version)
			return create_default_save()


func has_save() -> bool:
	"""Checks if a save file exists without loading it."""
	if OS.has_feature("web"):
		var result = JavaScriptBridge.eval("""
			localStorage.getItem('%s') !== null
		""" % [SAVE_KEY])
		return result if result != null else false
	else:
		return FileAccess.file_exists("user://save_data.json")


func _ready() -> void:
	"""Automatically load save on game start if it exists."""
	if has_save():
		if load_game():
			print("Save loaded successfully")
		else:
			push_warning("Save exists but failed to load, using defaults")
	else:
		print("No save found, using defaults")
		save_data = create_default_save()
