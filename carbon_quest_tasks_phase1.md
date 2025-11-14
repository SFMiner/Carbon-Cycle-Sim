# Carbon Quest: From Sunlight to Life - Complete Task List
## Phases 1-8: Full Development Roadmap
### For Claude Haiku 4.5 Execution

**Project**: Carbon Quest: From Sunlight to Life  
**Engine**: Godot 4.5  
**Language**: GDScript (tabs for indentation, NOT spaces)  
**Platform**: HTML5 (Web - Chromebook deployment)  
**GDD Version**: 1.1  
**Implementation Plan Version**: 1.1

**CRITICAL: All tasks defer to Implementation Plan and GDD documentation for specifications.**

---

---

## PHASE 1: Foundation & Architecture

**Phase Goal**: Establish project structure, core systems, and export pipeline  
**Duration**: 2 weeks  
**MVP Status**: Pre-MVP (Required Foundation)

---

### Task 1.1: Project Setup and Configuration
**Dependencies**: None  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create new Godot 4.5 project named "CarbonQuest"
2. Set project settings (Project → Project Settings):
   - Display/window/size/viewport_width = 1280
   - Display/window/size/viewport_height = 720
   - Display/window/stretch/mode = "viewport"
   - Display/window/stretch/aspect = "keep"
   - Rendering/textures/canvas_textures/default_texture_filter = "Nearest"
   - Physics/common/physics_ticks_per_second = 60
   - Application/config/name = "Carbon Quest: From Sunlight to Life"
3. Set background clear color:
   - Rendering/environment/defaults/default_clear_color = #87CEEB (light blue sky)
4. Create complete folder structure (use right-click → Create Folder in FileSystem):
   ```
   res://
   ├── scenes/
   │   ├── main/
   │   ├── stages/
   │   ├── molecules/
   │   ├── organisms/
   │   ├── ui/
   │   └── effects/
   ├── scripts/
   │   ├── autoload/
   │   ├── stages/
   │   ├── molecules/
   │   ├── organisms/
   │   ├── systems/
   │   └── ui/
   ├── assets/
   │   ├── sprites/
   │   │   ├── molecules/
   │   │   ├── organisms/
   │   │   ├── environment/
   │   │   └── ui/
   │   ├── audio/
   │   │   ├── sfx/
   │   │   └── music/
   │   └── fonts/
   └── data/
   ```
5. Create .gitignore file in project root with contents:
   ```
   .godot/
   .import/
   *.import
   builds/
   export_presets.cfg
   .DS_Store
   ```

**Human Checkpoint**:
- [ ] Project opens without errors in Godot 4.5
- [ ] Viewport shows 1280×720 resolution in editor
- [ ] All folders exist in FileSystem dock (check each one)
- [ ] Project Settings show correct display and rendering values
- [ ] Background color is light blue (#87CEEB) in default scene

---

### Task 1.2: HTML5 Export Preset Configuration
**Dependencies**: Task 1.1 (Project Setup)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open Project → Export
2. Click "Add..." and select "Web"
3. Configure export preset with these settings:
   - Name: "HTML5 - Chromebook"
   - Export Path: "builds/web/index.html"
   - Runnable: checked
   - Export Mode: Release (uncheck "Export with Debug")
   - Options → Custom HTML Shell: leave default
   - Options → Head Include: (leave blank)
   - Options → Progressive Web App: unchecked (not needed)
   - Texture Format → BPTC: unchecked
   - Texture Format → S3TC: checked
   - Texture Format → ETC: checked
   - Texture Format → ETC2: checked
4. Click "Export Project" to test build process (creates builds/web/ folder)
5. Verify index.html, .wasm, .pck, and .js files are created

**Human Checkpoint**:
- [ ] Export preset named "HTML5 - Chromebook" exists in Export dialog
- [ ] Export completes without errors (check Output panel)
- [ ] builds/web/ folder contains index.html and supporting files
- [ ] Opening builds/web/index.html in browser shows Godot default scene (empty but loads)

---

### Task 1.3: GameConstants AutoLoad Singleton
**Dependencies**: Task 1.1 (Project Setup)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: This singleton stores ALL game constants from the GDD to avoid magic numbers throughout codebase. Reference GDD Section 3 (Mechanics) for exact values.

**Implementation**:
1. Create `res://scripts/autoload/GameConstants.gd`
2. Extend Node class
3. Implement constants organized by category:

   **Reaction Formulas (from GDD Section 3.1 & 3.2)**:
   ```gdscript
   # Photosynthesis requirements
   const PHOTOSYNTHESIS_CO2_NEEDED: int = 6
   const PHOTOSYNTHESIS_H2O_NEEDED: int = 6
   const PHOTOSYNTHESIS_PHOTONS_NEEDED: int = 12
   const PHOTOSYNTHESIS_O2_PRODUCED: int = 6
   const PHOTOSYNTHESIS_GLUCOSE_PRODUCED: int = 1
   
   # Respiration requirements
   const RESPIRATION_GLUCOSE_NEEDED: int = 1
   const RESPIRATION_O2_NEEDED: int = 6
   const RESPIRATION_CO2_PRODUCED: int = 6
   const RESPIRATION_H2O_PRODUCED: int = 6
   const RESPIRATION_ATP_PRODUCED: int = 3
   ```

   **Workspace Capacities (from GDD Section 3.1 & 3.2)**:
   ```gdscript
   const STAGE1_WORKSPACE_CAPACITY: int = 20
   const STAGE2_WORKSPACE_CAPACITY: int = 15
   const WORKSPACE_RADIUS_STAGE1: int = 300  # pixels
   const WORKSPACE_WIDTH_STAGE2: int = 400   # pixels
   const WORKSPACE_HEIGHT_STAGE2: int = 250  # pixels
   ```

   **Molecule Spawn Rates (from GDD Section 3.1 & 3.2)**:
   ```gdscript
   const PHOTON_SPAWN_RATE: float = 2.0  # per second
   const CO2_SPAWN_RATE_STAGE1: float = 3.0  # per second
   const H2O_SPAWN_RATE: float = 3.0  # per second
   const GLUCOSE_SPAWN_RATE: float = 0.5  # per 2 seconds
   const O2_SPAWN_RATE_STAGE2: float = 4.0  # per second
   const MAX_MOLECULES_STAGE1: int = 30
   const MAX_MOLECULES_STAGE2: int = 25
   const MOLECULE_DESPAWN_TIME: float = 5.0  # seconds
   ```

   **Spawn Positions (from GDD Section 3.1 & 3.2)**:
   ```gdscript
   # Stage 1 spawn zones
   const PHOTON_SPAWN_X_MIN: int = 400
   const PHOTON_SPAWN_X_MAX: int = 880
   const PHOTON_SPAWN_Y: int = 0
   const CO2_SPAWN_X: int = 0
   const CO2_SPAWN_Y_MIN: int = 200
   const CO2_SPAWN_Y_MAX: int = 520
   const H2O_SPAWN_X_MIN: int = 400
   const H2O_SPAWN_X_MAX: int = 880
   const H2O_SPAWN_Y: int = 720
   const SPAWN_OFFSET_RANGE: int = 20  # +/- random offset
   
   # Stage 2 spawn zones
   const GLUCOSE_SPAWN_X: int = 0
   const GLUCOSE_SPAWN_Y_MIN: int = 300
   const GLUCOSE_SPAWN_Y_MAX: int = 420
   const O2_SPAWN_X: int = 1280
   const O2_SPAWN_Y_MIN: int = 200
   const O2_SPAWN_Y_MAX: int = 520
   ```

   **Workspace Centers (calculated)**:
   ```gdscript
   const WORKSPACE_CENTER_X: int = 640  # 1280 / 2
   const WORKSPACE_CENTER_Y: int = 360  # 720 / 2
   ```

   **Trash Zone (from GDD Section 3.1)**:
   ```gdscript
   const TRASH_ZONE_X_MIN: int = 1100
   const TRASH_ZONE_X_MAX: int = 1280
   const TRASH_ZONE_Y_MIN: int = 600
   const TRASH_ZONE_Y_MAX: int = 720
   ```

   **Stage 3 Atmosphere (from GDD Section 3.3)**:
   ```gdscript
   # Gas pools
   const ATMOSPHERE_MIN: int = 0
   const ATMOSPHERE_MAX: int = 200
   const ATMOSPHERE_INITIAL_CO2: int = 100
   const ATMOSPHERE_INITIAL_O2: int = 100
   const ATMOSPHERE_BALANCED_MIN: int = 50
   const ATMOSPHERE_BALANCED_MAX: int = 150
   const ATMOSPHERE_RECOVERY_THRESHOLD_LOW: int = 20
   const ATMOSPHERE_RECOVERY_THRESHOLD_HIGH: int = 180
   const ATMOSPHERE_RECOVERY_RATE: int = 2  # per tick
   
   # Organism parameters
   const PLANT_CO2_CONSUMPTION: int = 5  # per tick
   const PLANT_O2_PRODUCTION: int = 5    # per tick
   const ANIMAL_O2_CONSUMPTION: int = 3  # per tick
   const ANIMAL_CO2_PRODUCTION: int = 3  # per tick
   const ORGANISM_MAX_PLANTS: int = 10
   const ORGANISM_MAX_ANIMALS: int = 10
   const INITIAL_PLANTS: int = 3
   const INITIAL_ANIMALS: int = 3
   const ADD_BUTTON_COOLDOWN: float = 0.5  # seconds
   
   # Tick rate
   const TICK_RATE: float = 1.0  # seconds per tick
   
   # Balance timer
   const BALANCE_TIME_GOAL: float = 120.0  # seconds
   ```

   **Animation Timings (from GDD Section 3.1 & 3.2)**:
   ```gdscript
   const REACTION_SWIRL_DURATION: float = 0.8  # seconds
   const REACTION_SCALE_DURATION: float = 0.3  # seconds
   const O2_DRIFT_DURATION: float = 2.0  # seconds
   const GLUCOSE_SHATTER_DURATION: float = 0.6  # seconds
   const ATP_BOLT_DURATION: float = 0.5  # seconds
   const ATP_BOLT_LENGTH: int = 128  # pixels
   const DELETION_ANIMATION_DURATION: float = 0.3  # seconds
   const STAGE_TRANSITION_FADE: float = 0.5  # seconds
   ```

   **Molecule Behavior (from GDD Section 3.1)**:
   ```gdscript
   const MOLECULE_COLLISION_RADIUS: int = 32  # pixels
   const MOLECULE_SEPARATION_FORCE: float = 10.0  # pixels per second
   const MOLECULE_DRAG_COOLDOWN: float = 0.2  # seconds after release
   ```

   **Color Constants (from GDD Section 6)**:
   ```gdscript
   const COLOR_SKY: Color = Color("#87CEEB")
   const COLOR_SOIL: Color = Color("#8B4513")
   const COLOR_SUN: Color = Color("#FFD700")
   const COLOR_PHOTON: Color = Color("#FFFF00")
   const COLOR_CO2_BASE: Color = Color("#808080")
   const COLOR_CO2_DOTS: Color = Color("#FF0000")
   const COLOR_H2O_BASE: Color = Color("#FF0000")
   const COLOR_H2O_DOTS: Color = Color("#FFFFFF")
   const COLOR_O2: Color = Color("#FF0000")
   const COLOR_GLUCOSE: Color = Color("#DAA520")
   const COLOR_CHLOROPLAST: Color = Color("#90EE90")
   const COLOR_MITOCHONDRIA: Color = Color("#FFB347")
   const COLOR_PLANT: Color = Color("#228B22")
   const COLOR_ANIMAL: Color = Color("#8B4513")
   ```

   **Stage Target Goals (from GDD Section 2)**:
   ```gdscript
   const STAGE1_GLUCOSE_TARGET: int = 5
   const STAGE2_GLUCOSE_TARGET: int = 5
   ```

4. Use tabs for indentation (NOT spaces)
5. Add type hints to all constants (shown above)
6. Configure as AutoLoad singleton:
   - Project → Project Settings → Autoload
   - Path: `res://scripts/autoload/GameConstants.gd`
   - Node Name: `GameConstants`
   - Enable: checked

**Human Checkpoint**:
- [ ] Script runs without errors (F6 to test)
- [ ] "GameConstants" appears in Project → Project Settings → Autoload
- [ ] All constants use `const` keyword (not `var`)
- [ ] All constants have type hints (`: int`, `: float`, `: Color`)
- [ ] Indentation uses tabs (open file, check white space)
- [ ] Can print constant in test: `print(GameConstants.PHOTOSYNTHESIS_CO2_NEEDED)` outputs `6`

---

### Task 1.4: GameManager AutoLoad Singleton
**Dependencies**: Task 1.3 (GameConstants)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: This singleton manages game state, stage progression, and statistics tracking across the entire game. Reference GDD Section 7 (Technical Architecture).

**Implementation**:
1. Create `res://scripts/autoload/GameManager.gd`
2. Extend Node class
3. Implement state tracking variables:
   ```gdscript
   extends Node
   
   # Current game state
   var current_stage: int = 1  # 1, 2, or 3
   var stages_completed: Array[int] = []  # List of completed stage numbers
   
   # Stage 1 & 2 statistics
   var glucose_created: int = 0
   var glucose_broken_down: int = 0
   var stage1_reactions: int = 0
   var stage2_reactions: int = 0
   var stage1_start_time: float = 0.0
   var stage2_start_time: float = 0.0
   
   # Stage 3 statistics
   var balance_time: float = 0.0  # Total seconds in balanced state
   var stage3_start_time: float = 0.0
   
   # Session tracking
   var total_reactions: int = 0
   ```

4. Implement signals (declare after extends Node):
   ```gdscript
   signal stage_completed(stage_num: int)
   signal game_completed()
   signal glucose_created_updated(count: int)
   signal glucose_broken_updated(count: int)
   signal balance_time_updated(time: float)
   ```

5. Implement core functions:
   ```gdscript
   func _ready() -> void:
   	reset_game_state()
   
   func reset_game_state() -> void:
   	"""Reset all game state to initial values."""
   	current_stage = 1
   	stages_completed.clear()
   	glucose_created = 0
   	glucose_broken_down = 0
   	stage1_reactions = 0
   	stage2_reactions = 0
   	balance_time = 0.0
   	total_reactions = 0
   
   func start_stage(stage_num: int) -> void:
   	"""Initialize state for beginning a stage."""
   	current_stage = stage_num
   	match stage_num:
   		1:
   			glucose_created = 0
   			stage1_reactions = 0
   			stage1_start_time = Time.get_ticks_msec() / 1000.0
   		2:
   			glucose_broken_down = 0
   			stage2_reactions = 0
   			stage2_start_time = Time.get_ticks_msec() / 1000.0
   		3:
   			balance_time = 0.0
   			stage3_start_time = Time.get_ticks_msec() / 1000.0
   
   func complete_stage(stage_num: int) -> void:
   	"""Mark stage as completed and emit signal."""
   	if stage_num not in stages_completed:
   		stages_completed.append(stage_num)
   	stage_completed.emit(stage_num)
   	
   	# Check if all stages complete
   	if stages_completed.size() == 3:
   		game_completed.emit()
   
   func advance_to_stage_2() -> void:
   	"""Progress to Stage 2."""
   	complete_stage(1)
   	start_stage(2)
   
   func advance_to_stage_3() -> void:
   	"""Progress to Stage 3."""
   	complete_stage(2)
   	start_stage(3)
   
   func increment_glucose_created() -> void:
   	"""Called when photosynthesis reaction occurs."""
   	glucose_created += 1
   	stage1_reactions += 1
   	total_reactions += 1
   	glucose_created_updated.emit(glucose_created)
   
   func increment_glucose_broken() -> void:
   	"""Called when respiration reaction occurs."""
   	glucose_broken_down += 1
   	stage2_reactions += 1
   	total_reactions += 1
   	glucose_broken_updated.emit(glucose_broken_down)
   
   func update_balance_time(delta: float) -> void:
   	"""Called each frame when ecosystem is balanced."""
   	balance_time += delta
   	balance_time_updated.emit(balance_time)
   
   func get_stage1_completion_time() -> float:
   	"""Returns time taken to complete Stage 1 in seconds."""
   	return (Time.get_ticks_msec() / 1000.0) - stage1_start_time
   
   func get_stage2_completion_time() -> float:
   	"""Returns time taken to complete Stage 2 in seconds."""
   	return (Time.get_ticks_msec() / 1000.0) - stage2_start_time
   
   func is_stage_complete(stage_num: int) -> bool:
   	"""Check if a specific stage is completed."""
   	return stage_num in stages_completed
   ```

6. Use tabs for indentation
7. Add type hints to all variables and functions (shown above)
8. Configure as AutoLoad singleton:
   - Project → Project Settings → Autoload
   - Path: `res://scripts/autoload/GameManager.gd`
   - Node Name: `GameManager`
   - Enable: checked

**Human Checkpoint**:
- [ ] Script runs without errors (F6 to test)
- [ ] "GameManager" appears in Project → Project Settings → Autoload
- [ ] All variables have type hints
- [ ] All functions have type hints (parameters and return types)
- [ ] Indentation uses tabs
- [ ] Test signal: Add `print("Stage completed: ", stage)` in `_ready()`, connect to signal, emit it manually - prints correctly
- [ ] Test functions: `GameManager.increment_glucose_created()` increases `glucose_created` to 1

---

### Task 1.5: SaveSystem AutoLoad Singleton - Data Structures
**Dependencies**: Task 1.3 (GameConstants), Task 1.4 (GameManager)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: This singleton handles save/load via localStorage for web. This task focuses on data structure setup. Reference GDD Section 7 (Save System) for exact format.

**Implementation**:
1. Create `res://scripts/autoload/SaveSystem.gd`
2. Extend Node class
3. Define save data structure constant:
   ```gdscript
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
   ```

4. Implement helper functions for data structure:
   ```gdscript
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
   ```

5. Add stub functions for save/load (will implement in next task):
   ```gdscript
   func save_game() -> bool:
   	"""Saves current game state to localStorage. Returns true on success."""
   	# TODO: Implement in Task 1.6
   	return false
   
   func load_game() -> bool:
   	"""Loads game state from localStorage. Returns true if save exists."""
   	# TODO: Implement in Task 1.6
   	return false
   
   func has_save() -> bool:
   	"""Checks if a save file exists."""
   	# TODO: Implement in Task 1.6
   	return false
   ```

6. Use tabs for indentation
7. Add type hints to all variables and functions
8. Configure as AutoLoad singleton:
   - Project → Project Settings → Autoload
   - Path: `res://scripts/autoload/SaveSystem.gd`
   - Node Name: `SaveSystem`
   - Enable: checked

**Human Checkpoint**:
- [ ] Script runs without errors (F6 to test)
- [ ] "SaveSystem" appears in Project → Project Settings → Autoload
- [ ] `create_default_save()` returns dictionary with all required keys
- [ ] `update_from_game_manager()` runs without errors (even though GameManager state is default)
- [ ] All type hints present
- [ ] Indentation uses tabs
- [ ] Test: `print(SaveSystem.save_data["version"])` outputs "1.1"

---

### Task 1.6: SaveSystem AutoLoad Singleton - localStorage Integration
**Dependencies**: Task 1.5 (SaveSystem Data Structures)  
**Extended thinking**: ON  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **ON**."

**Context**: Implement actual save/load using localStorage via JavaScriptBridge for web export. This requires handling browser-specific quirks, versioning, and error cases. Reference GDD Section 7 for migration strategy.

**Implementation**:
1. Open `res://scripts/autoload/SaveSystem.gd`
2. Implement `save_game()` function:
   ```gdscript
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
   ```

3. Implement `load_game()` function with versioning:
   ```gdscript
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
   ```

4. Implement versioning migration function:
   ```gdscript
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
   ```

5. Implement `has_save()` function:
   ```gdscript
   func has_save() -> bool:
   	"""Checks if a save file exists without loading it."""
   	if OS.has_feature("web"):
   		var result = JavaScriptBridge.eval("""
   			localStorage.getItem('%s') !== null
   		""" % [SAVE_KEY])
   		return result if result != null else false
   	else:
   		return FileAccess.file_exists("user://save_data.json")
   ```

6. Add `_ready()` function to auto-load on game start:
   ```gdscript
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
   ```

7. Ensure all type hints present and tabs used for indentation

**Human Checkpoint**:
- [ ] Script compiles without errors (F6 to test)
- [ ] `SaveSystem._ready()` runs and prints "No save found" on first run
- [ ] Test save: Run `SaveSystem.save_game()` in console, returns `true`
- [ ] Test load: Run `SaveSystem.load_game()` in console, returns `true`
- [ ] For web: Open browser DevTools → Application → Local Storage → verify "carbon_quest_save_data" key exists with JSON value
- [ ] Test migration: Manually edit localStorage to have `"version": "1.0"`, reload, migration runs and adds new fields
- [ ] All functions have type hints and proper error handling

---

### Task 1.7: equations.json Data File
**Dependencies**: Task 1.1 (Project Setup)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: Create JSON file storing chemical reaction formulas for easy reference throughout the game. Reference GDD Appendix for exact equations.

**Implementation**:
1. Create `res://data/equations.json` file
2. Write JSON structure with photosynthesis and respiration equations:
   ```json
   {
   	"photosynthesis": {
   		"name": "Photosynthesis",
   		"equation_text": "6 CO₂ + 6 H₂O + Light Energy → C₆H₁₂O₆ + 6 O₂",
   		"equation_plain": "6 CO2 + 6 H2O + Light -> C6H12O6 + 6 O2",
   		"inputs": {
   			"CO2": 6,
   			"H2O": 6,
   			"photons": 12
   		},
   		"outputs": {
   			"glucose": 1,
   			"O2": 6
   		},
   		"description": "Plants use sunlight to convert carbon dioxide and water into glucose and oxygen."
   	},
   	"respiration": {
   		"name": "Cellular Respiration",
   		"equation_text": "C₆H₁₂O₆ + 6 O₂ → 6 CO₂ + 6 H₂O + ATP (Energy)",
   		"equation_plain": "C6H12O6 + 6 O2 -> 6 CO2 + 6 H2O + Energy",
   		"inputs": {
   			"glucose": 1,
   			"O2": 6
   		},
   		"outputs": {
   			"CO2": 6,
   			"H2O": 6,
   			"ATP": 3
   		},
   		"description": "Cells break down glucose using oxygen to release energy, producing carbon dioxide and water."
   	},
   	"carbon_cycle": {
   		"name": "Carbon Cycle",
   		"description": "The continuous movement of carbon between living organisms and the atmosphere. Plants perform photosynthesis (using CO₂, producing O₂), while animals perform cellular respiration (using O₂, producing CO₂). These processes are complementary - the outputs of one become the inputs of the other."
   	}
   }
   ```

3. Save file (Godot will auto-import as text resource)

**Human Checkpoint**:
- [ ] File `res://data/equations.json` exists in FileSystem dock
- [ ] File opens without errors when double-clicked
- [ ] JSON is valid (no syntax errors)
- [ ] Test loading: Create test script with:
   ```gdscript
   var file = FileAccess.open("res://data/equations.json", FileAccess.READ)
   var json_text = file.get_as_text()
   var json = JSON.new()
   json.parse(json_text)
   print(json.data["photosynthesis"]["name"])  # Should print "Photosynthesis"
   ```
- [ ] Test script prints "Photosynthesis" correctly

---

### Task 1.8: Placeholder Sprite Assets
**Dependencies**: Task 1.1 (Project Setup)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: Create simple colored-circle placeholder sprites for molecules so we can test visual elements before final art. Reference GDD Section 6 for colors.

**Implementation**:
1. For each molecule type, create a simple colored circle sprite using Godot's built-in tools:

   **Photon** (Yellow):
   - Scene → New Scene → Node2D
   - Add child: Sprite2D
   - In Sprite2D, Texture → New GradientTexture2D
   - GradientTexture2D → Gradient → New Gradient
   - Edit Gradient: Color at 0.0 = #FFFF00 (yellow), Color at 1.0 = #FFFF00
   - GradientTexture2D → Width = 32, Height = 32
   - GradientTexture2D → Fill → Set to Radial
   - Save scene as `res://assets/sprites/molecules/photon_placeholder.png` (use FileSystem → right-click texture → Export)
   - Or: Just use ColorRect with yellow background for now (simpler)

2. Actually, simpler approach: Create placeholder sprites as ColorRect nodes in code later. For now, just create empty folders to confirm structure:
   - `res://assets/sprites/molecules/` (already exists from Task 1.1)
   - `res://assets/sprites/organisms/`
   - `res://assets/sprites/environment/`
   - `res://assets/sprites/ui/`

3. Create a reference document listing needed sprites:
   Create `res://assets/sprites/SPRITE_LIST.md`:
   ```markdown
   # Carbon Quest - Sprite Asset List
   
   ## Molecules (32×32px or 64×64px)
   - [ ] photon.png - Yellow glowing circle
   - [ ] co2.png - Gray sphere with red dots (+ diagonal stripes for colorblind)
   - [ ] h2o.png - Red sphere with white dots (+ horizontal stripes for colorblind)
   - [ ] o2.png - Red sphere (solid)
   - [ ] glucose.png - Golden hexagon (128×128px, + checkerboard for colorblind)
   
   ## Organisms (64×64px)
   - [ ] plant.png - Green plant with 2-3 leaves
   - [ ] animal.png - Brown mouse-like creature
   
   ## Environment
   - [ ] sun_rays.png - Diagonal light beams
   - [ ] soil_texture.png - Brown tile pattern
   - [ ] trash_can.png - Trash icon with red border
   
   ## UI
   - [ ] arrow_tutorial.png - White arrow for tutorials
   - [ ] button_add.png - Plus icon for add buttons
   
   ## Effects
   - [ ] particle_sparkle.png - Green sparkle
   - [ ] particle_burst.png - Orange burst
   - [ ] atp_bolt.png - Yellow lightning bolt
   
   ## Patterns (for colorblind mode overlays)
   - [ ] pattern_diagonal.png - Diagonal stripe pattern
   - [ ] pattern_horizontal.png - Horizontal stripe pattern
   - [ ] pattern_checkerboard.png - Checkerboard pattern
   ```

4. Create font placeholder:
   - Download Roboto-Regular.ttf from Google Fonts (or use any open-source font)
   - Place in `res://assets/fonts/`
   - OR: Use Godot's default font for now (no file needed)

**Human Checkpoint**:
- [ ] All sprite folders exist in FileSystem dock
- [ ] SPRITE_LIST.md exists and lists all needed assets
- [ ] Font file exists in `res://assets/fonts/` (or decision made to use default font)
- [ ] Placeholder strategy confirmed (will use ColorRect nodes for now, replace with real sprites later)

---

### Task 1.9: Main Scene Setup
**Dependencies**: Task 1.1 (Project Setup), Task 1.3-1.6 (AutoLoad singletons)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: Create the main entry point scene that will load at game start. For now, it's just a placeholder that proves the project structure works.

**Implementation**:
1. Create `res://scenes/main/Main.tscn`:
   - Scene → New Scene
   - Root node: Node2D (name it "Main")
   - Save as `res://scenes/main/Main.tscn`

2. Add child nodes for basic structure:
   - Add child: ColorRect (name it "Background")
     - Anchor preset: Full Rect
     - Color: #87CEEB (light blue sky from GameConstants)
   - Add child: Label (name it "TitleLabel")
     - Text: "Carbon Quest: From Sunlight to Life"
     - Horizontal Alignment: Center
     - Position: x=640, y=100 (center-top)
     - Anchor: Center Top
   - Add child: Label (name it "StatusLabel")
     - Text: "Phase 1 Complete - Foundation Established"
     - Horizontal Alignment: Center
     - Position: x=640, y=360 (center)
     - Anchor: Center

3. Set Main.tscn as the main scene:
   - Project → Project Settings → Application → Run → Main Scene
   - Set to `res://scenes/main/Main.tscn`

4. Test run (F5):
   - Should see light blue background with centered text
   - No errors in Output panel

**Human Checkpoint**:
- [ ] Main.tscn opens without errors
- [ ] Scene hierarchy shows Main → Background, TitleLabel, StatusLabel
- [ ] Background is light blue color
- [ ] Running project (F5) shows the scene correctly
- [ ] Project → Project Settings shows Main.tscn as main scene
- [ ] No errors or warnings in Output panel

---

### Task 1.10: Git Repository Initialization
**Dependencies**: Task 1.1 (Project Setup), Task 1.9 (Main scene exists)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Context**: Initialize Git repository for version control. This is optional but recommended for tracking progress.

**Implementation**:
1. Open terminal in project root directory
2. Initialize Git repository:
   ```bash
   git init
   ```

3. Verify .gitignore exists (created in Task 1.1)
4. Stage all files:
   ```bash
   git add .
   ```

5. Create initial commit:
   ```bash
   git commit -m "Phase 1 Complete: Foundation & Architecture
   
   - Project setup with Godot 4.5
   - HTML5 export configured
   - AutoLoad singletons: GameConstants, GameManager, SaveSystem
   - Data structures and save system with versioning
   - Placeholder assets and folder structure
   - Main scene entry point
   
   Ready for Phase 2: Draggable Molecule System"
   ```

6. (Optional) Create GitHub repository and push:
   ```bash
   git remote add origin [your-github-url]
   git branch -M main
   git push -u origin main
   ```

**Human Checkpoint**:
- [ ] `git status` shows clean working directory (or GitHub remote configured)
- [ ] `.git` folder exists in project root
- [ ] `git log` shows initial commit with Phase 1 message
- [ ] All game files are committed (check: scripts, scenes, data folders)
- [ ] .godot and .import folders are NOT in git (excluded by .gitignore)

---

## PHASE 1 COMPLETION VERIFICATION

Before proceeding to Phase 2, verify ALL of the following:

### Project Structure
- [ ] Godot 4.5 project opens without errors
- [ ] Resolution set to 1280×720
- [ ] HTML5 export preset configured and builds successfully
- [ ] Complete folder structure exists (scenes, scripts, assets, data)

### AutoLoad Singletons
- [ ] GameConstants configured in AutoLoad with all constants from GDD
- [ ] GameManager configured in AutoLoad with state tracking and signals
- [ ] SaveSystem configured in AutoLoad with localStorage integration

### Data & Assets
- [ ] equations.json exists and loads correctly
- [ ] Sprite folder structure established
- [ ] SPRITE_LIST.md documents all needed assets
- [ ] Font available (Roboto or default)

### Core Systems
- [ ] Save/load works (test manually in browser console)
- [ ] Save versioning handles migration from v1.0 to v1.1
- [ ] Main.tscn loads as main scene
- [ ] No compilation errors anywhere

### Version Control
- [ ] Git repository initialized (optional)
- [ ] Initial commit created (optional)
- [ ] .gitignore excludes .godot and .import

### Performance Check
- [ ] HTML5 build loads in browser (<10 seconds on local file)
- [ ] No console errors in browser DevTools
- [ ] localStorage save/load works in browser

---

## 🎯 PHASE 1 COMPLETE!

**Estimated time to complete Phase 1: 1-2 weeks**

You now have a solid foundation with:
✅ Complete project structure  
✅ All AutoLoad singletons functional  
✅ Save system with browser localStorage  
✅ Export pipeline configured  
✅ Version control established  

**Next Step**: Proceed to Phase 2 task list (Draggable Molecule System)

---

## PHASE 2: Draggable Molecule System

**Phase Goal**: Implement core molecule dragging, spawning, and workspace mechanics  
**Duration**: 2-3 weeks  
**MVP Status**: Pre-MVP (Core Mechanic)

---

### Task 2.1: Base Molecule Script
**Dependencies**: Phase 1 Complete (GameConstants)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/molecules/Molecule.gd`
2. Extend Area2D class (for collision detection)
3. Define molecule type enum and state machine:
   ```gdscript
   extends Area2D
   class_name Molecule
   
   enum MoleculeType {PHOTON, CO2, H2O, O2, GLUCOSE}
   enum State {IDLE, BEING_DRAGGED, IN_WORKSPACE, DESPAWNING}
   
   @export var molecule_type: MoleculeType = MoleculeType.CO2
   var current_state: State = State.IDLE
   var drag_offset: Vector2 = Vector2.ZERO
   var time_since_spawn: float = 0.0
   var can_be_grabbed: bool = true
   var grab_cooldown_timer: float = 0.0
   ```

4. Implement signals:
   ```gdscript
   signal picked_up(molecule: Molecule)
   signal dropped(molecule: Molecule, position: Vector2)
   signal entered_workspace(molecule: Molecule)
   signal exited_workspace(molecule: Molecule)
   signal despawned(molecule: Molecule)
   ```

5. Implement core functions (stubs for now):
   ```gdscript
   func _ready() -> void:
   	# Configure collision
   	collision_layer = 2  # Layer 2 for molecules
   	collision_mask = 0   # Don't collide with anything
   	monitoring = true
   	monitorable = true
   	
   	# Connect input events
   	input_event.connect(_on_input_event)
   	mouse_entered.connect(_on_mouse_entered)
   	mouse_exited.connect(_on_mouse_exited)
   
   func _process(delta: float) -> void:
   	match current_state:
   		State.IDLE:
   			_process_idle(delta)
   		State.BEING_DRAGGED:
   			_process_dragging(delta)
   		State.IN_WORKSPACE:
   			_process_in_workspace(delta)
   		State.DESPAWNING:
   			_process_despawning(delta)
   	
   	# Update grab cooldown
   	if grab_cooldown_timer > 0:
   		grab_cooldown_timer -= delta
   		can_be_grabbed = grab_cooldown_timer <= 0
   
   func _process_idle(delta: float) -> void:
   	time_since_spawn += delta
   	if time_since_spawn >= GameConstants.MOLECULE_DESPAWN_TIME:
   		despawn()
   
   func _process_dragging(delta: float) -> void:
   	global_position = get_global_mouse_position() + drag_offset
   
   func _process_in_workspace(delta: float) -> void:
   	pass  # Stub for now
   
   func _process_despawning(delta: float) -> void:
   	pass  # Will implement fade-out animation later
   
   func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
   	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
   		if can_be_grabbed and current_state == State.IDLE:
   			start_drag()
   
   func _on_mouse_entered() -> void:
   	if can_be_grabbed:
   		show_hover_feedback()
   
   func _on_mouse_exited() -> void:
   		hide_hover_feedback()
   
   func start_drag() -> void:
   	current_state = State.BEING_DRAGGED
   	drag_offset = global_position - get_global_mouse_position()
   	z_index = 10  # Bring to front while dragging
   	picked_up.emit(self)
   
   func stop_drag() -> void:
   	current_state = State.IDLE
   	z_index = 0
   	grab_cooldown_timer = GameConstants.MOLECULE_DRAG_COOLDOWN
   	can_be_grabbed = false
   	dropped.emit(self, global_position)
   
   func despawn() -> void:
   	current_state = State.DESPAWNING
   	despawned.emit(self)
   	queue_free()  # For now, will add animation later
   
   func show_hover_feedback() -> void:
   	pass  # Stub - will add white outline later
   
   func hide_hover_feedback() -> void:
   	pass  # Stub
   ```

6. Use tabs for indentation, type hints on all variables and functions
7. Save script

**Human Checkpoint**:
- [ ] Script compiles without errors (F6 to test)
- [ ] Class name "Molecule" recognized in Godot
- [ ] Enum types defined (MoleculeType, State)
- [ ] All signals declared
- [ ] All functions have type hints
- [ ] Indentation uses tabs

---

### Task 2.2: Base Molecule Scene
**Dependencies**: Task 2.1 (Molecule script)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scenes/molecules/Molecule.tscn`:
   - Root: Area2D (attach script: `res://scripts/molecules/Molecule.gd`)
   - Name root: "Molecule"

2. Add child nodes:
   - Add Sprite2D (name: "Sprite")
	 - Texture: Create new `GradientTexture2D`
	 - GradientTexture2D → Width: 64, Height: 64
	 - GradientTexture2D → Fill: Radial
	 - GradientTexture2D → Gradient: New Gradient
	 - Gradient → Color at 0.0: White, Color at 1.0: Gray (placeholder)
   
   - Add CollisionShape2D (name: "CollisionShape")
	 - Shape: New CircleShape2D
	 - CircleShape2D → Radius: 32
   
   - Add Line2D (name: "HoverOutline")
	 - Points: Create circle outline (8 points around radius 36)
	 - Width: 3
	 - Default Color: White with alpha 0 (invisible by default)
	 - Visible: false

3. Configure Area2D properties:
   - Collision Layer: Layer 2 (molecules)
   - Collision Mask: 0 (don't detect collisions)
   - Monitoring: On
   - Monitorable: On

4. Save scene

**Human Checkpoint**:
- [ ] Scene opens without errors
- [ ] Hierarchy: Molecule (Area2D) → Sprite, CollisionShape, HoverOutline
- [ ] Sprite shows as circular gradient (placeholder)
- [ ] CollisionShape2D has circle of radius 32
- [ ] HoverOutline is invisible by default
- [ ] Can instantiate scene in test scene (drag into 2D viewport)

---

### Task 2.3: Molecule Dragging Implementation
**Dependencies**: Task 2.2 (Molecule scene)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open `res://scripts/molecules/Molecule.gd`
2. Implement hover feedback functions:
   ```gdscript
   func show_hover_feedback() -> void:
   	var outline = get_node_or_null("HoverOutline")
   	if outline:
   		outline.visible = true
   		outline.default_color = Color.WHITE
   
   func hide_hover_feedback() -> void:
   	var outline = get_node_or_null("HoverOutline")
   	if outline:
   		outline.visible = false
   ```

3. Add input handling for releasing drag:
   ```gdscript
   func _input(event: InputEvent) -> void:
   	if current_state == State.BEING_DRAGGED:
   		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
   			stop_drag()
   ```

4. Update `stop_drag()` to check if in valid drop zone:
   ```gdscript
   func stop_drag() -> void:
   	current_state = State.IDLE
   	z_index = 0
   	grab_cooldown_timer = GameConstants.MOLECULE_DRAG_COOLDOWN
   	can_be_grabbed = false
   	dropped.emit(self, global_position)
   	
   	# Check if dropped in workspace or trash
   	# This will be implemented when workspace exists
   ```

5. Add visual feedback during drag (scale up slightly):
   ```gdscript
   func start_drag() -> void:
   	current_state = State.BEING_DRAGGED
   	drag_offset = global_position - get_global_mouse_position()
   	z_index = 10
   	scale = Vector2(1.1, 1.1)  # Slight scale up
   	picked_up.emit(self)
   
   func stop_drag() -> void:
   	current_state = State.IDLE
   	z_index = 0
   	scale = Vector2(1.0, 1.0)  # Back to normal
   	grab_cooldown_timer = GameConstants.MOLECULE_DRAG_COOLDOWN
   	can_be_grabbed = false
   	dropped.emit(self, global_position)
   ```

6. Test by creating test scene:
   - Create `res://scenes/test/TestDrag.tscn`
   - Root: Node2D
   - Instance `Molecule.tscn` as child
   - Set molecule position to center (640, 360)
   - Run scene (F6)

**Human Checkpoint**:
- [ ] Hovering over molecule shows white outline
- [ ] Clicking molecule starts drag (molecule follows cursor)
- [ ] Molecule scales to 1.1× while dragging
- [ ] Releasing mouse button stops drag
- [ ] Molecule returns to scale 1.0 after drop
- [ ] Cannot re-grab for 0.2 seconds after drop
- [ ] Dragged molecule appears on top (z-index 10)

---

### Task 2.4: Molecule Type Variants
**Dependencies**: Task 2.3 (Dragging works)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create variant scenes for each molecule type by inheriting from Molecule.tscn:

   **Photon.tscn**:
   - Scene → New Inherited Scene → Inherit from `Molecule.tscn`
   - Root node → Script → molecule_type = MoleculeType.PHOTON
   - Sprite → Modulate = #FFFF00 (yellow)
   - Add glow effect: CanvasLayer with LightOccluder2D (optional, or skip for now)
   - Save as `res://scenes/molecules/Photon.tscn`

   **CO2.tscn**:
   - Inherit from Molecule.tscn
   - molecule_type = MoleculeType.CO2
   - Sprite → Modulate = #808080 (gray)
   - Save as `res://scenes/molecules/CO2.tscn`

   **H2O.tscn**:
   - Inherit from Molecule.tscn
   - molecule_type = MoleculeType.H2O
   - Sprite → Modulate = #FF0000 (red)
   - Save as `res://scenes/molecules/H2O.tscn`

   **O2.tscn**:
   - Inherit from Molecule.tscn
   - molecule_type = MoleculeType.O2
   - Sprite → Modulate = #FF0000 (red)
   - Save as `res://scenes/molecules/O2.tscn`

   **Glucose.tscn**:
   - Inherit from Molecule.tscn
   - molecule_type = MoleculeType.GLUCOSE
   - Sprite → Modulate = #DAA520 (golden brown)
   - Sprite → Scale = 2.0 (larger than other molecules)
   - CollisionShape → Radius = 64 (larger collision)
   - Save as `res://scenes/molecules/Glucose.tscn`

2. Update Molecule.gd to set collision shape based on type:
   ```gdscript
   func _ready() -> void:
   	# Existing code...
   	
   	# Adjust collision size for glucose
   	if molecule_type == MoleculeType.GLUCOSE:
   		var collision = get_node("CollisionShape") as CollisionShape2D
   		if collision and collision.shape is CircleShape2D:
   			collision.shape.radius = 64
   ```

**Human Checkpoint**:
- [ ] All 5 molecule variant scenes exist (Photon, CO2, H2O, O2, Glucose)
- [ ] Each scene inherits from Molecule.tscn
- [ ] Each has correct color (yellow, gray, red, red, golden)
- [ ] Glucose is larger (scale 2.0)
- [ ] Each can be dragged independently
- [ ] Test: Instance all 5 in test scene, all drag correctly

---

### Task 2.5: Molecule Spawner System - Base Implementation
**Dependencies**: Task 2.4 (Molecule variants exist)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/systems/MoleculeSpawner.gd`:
   ```gdscript
   extends Node2D
   class_name MoleculeSpawner
   
   # Spawner configuration
   @export var molecule_scene: PackedScene
   @export var spawn_rate: float = 2.0  # molecules per second
   @export var spawn_zone_min: Vector2 = Vector2.ZERO
   @export var spawn_zone_max: Vector2 = Vector2(100, 100)
   @export var max_molecules: int = 30
   @export var enabled: bool = true
   
   # Internal state
   var spawn_timer: Timer
   var active_molecules: Array[Molecule] = []
   var molecule_pool: Array[Molecule] = []
   
   func _ready() -> void:
   	# Create spawn timer
   	spawn_timer = Timer.new()
   	add_child(spawn_timer)
   	spawn_timer.wait_time = 1.0 / spawn_rate
   	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
   	spawn_timer.start()
   
   func _on_spawn_timer_timeout() -> void:
   	if enabled and active_molecules.size() < max_molecules:
   		spawn_molecule()
   
   func spawn_molecule() -> void:
   	var molecule: Molecule
   	
   	# Try to get from pool first
   	if molecule_pool.size() > 0:
   		molecule = molecule_pool.pop_back()
   		molecule.visible = true
   		molecule.process_mode = Node.PROCESS_MODE_INHERIT
   	else:
   		# Create new instance
   		if molecule_scene:
   			molecule = molecule_scene.instantiate() as Molecule
   			get_tree().current_scene.add_child(molecule)
   			molecule.despawned.connect(_on_molecule_despawned)
   	
   	if molecule:
   		# Set spawn position with random offset
   		var spawn_pos = Vector2(
   			randf_range(spawn_zone_min.x, spawn_zone_max.x),
   			randf_range(spawn_zone_min.y, spawn_zone_max.y)
   		)
   		var offset = Vector2(
   			randf_range(-GameConstants.SPAWN_OFFSET_RANGE, GameConstants.SPAWN_OFFSET_RANGE),
   			randf_range(-GameConstants.SPAWN_OFFSET_RANGE, GameConstants.SPAWN_OFFSET_RANGE)
   		)
   		molecule.global_position = spawn_pos + offset
   		molecule.time_since_spawn = 0.0
   		molecule.current_state = Molecule.State.IDLE
   		
   		active_molecules.append(molecule)
   
   func _on_molecule_despawned(molecule: Molecule) -> void:
   	active_molecules.erase(molecule)
   	
   	# Return to pool instead of freeing
   	molecule.visible = false
   	molecule.process_mode = Node.PROCESS_MODE_DISABLED
   	molecule_pool.append(molecule)
   
   func clear_all_molecules() -> void:
   	"""Remove all active molecules (for stage restart)."""
   	for molecule in active_molecules:
   		molecule.queue_free()
   	active_molecules.clear()
   	
   	for molecule in molecule_pool:
   		molecule.queue_free()
   	molecule_pool.clear()
   
   func set_enabled(value: bool) -> void:
   	enabled = value
   	if spawn_timer:
   		if enabled:
   			spawn_timer.start()
   		else:
   			spawn_timer.stop()
   ```

2. Use tabs, type hints throughout
3. Save script

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Class name "MoleculeSpawner" recognized
- [ ] Object pooling logic present (reuses molecules)
- [ ] All type hints present
- [ ] Indentation uses tabs

---

### Task 2.6: Molecule Spawner Testing Scene
**Dependencies**: Task 2.5 (MoleculeSpawner script)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scenes/test/TestSpawner.tscn`:
   - Root: Node2D (name: "TestSpawner")
   - Add child: ColorRect (name: "Background")
     - Anchor preset: Full Rect
     - Color: #87CEEB (light blue)

2. Add MoleculeSpawner for photons:
   - Add child to root: Node2D (attach `MoleculeSpawner.gd`)
   - Name: "PhotonSpawner"
   - Configure in Inspector:
     - molecule_scene: Load `Photon.tscn`
     - spawn_rate: 2.0
     - spawn_zone_min: (400, 0)
     - spawn_zone_max: (880, 0)
     - max_molecules: 30
     - enabled: true

3. Add spawners for CO2 and H2O:
   - Duplicate PhotonSpawner → Name: "CO2Spawner"
     - molecule_scene: CO2.tscn
     - spawn_rate: 3.0
     - spawn_zone_min: (0, 200)
     - spawn_zone_max: (0, 520)
   
   - Duplicate PhotonSpawner → Name: "H2OSpawner"
     - molecule_scene: H2O.tscn
     - spawn_rate: 3.0
     - spawn_zone_min: (400, 720)
     - spawn_zone_max: (880, 720)

4. Add Label for debug info:
   - Add child: Label (name: "DebugLabel")
   - Position: (10, 10)
   - Text: "Molecule count: 0"

5. Attach script to root to display count:
   ```gdscript
   extends Node2D
   
   func _process(delta: float) -> void:
   	var total = 0
   	total += $PhotonSpawner.active_molecules.size()
   	total += $CO2Spawner.active_molecules.size()
   	total += $H2OSpawner.active_molecules.size()
   	$DebugLabel.text = "Molecule count: %d" % total
   ```

6. Run scene (F6)

**Human Checkpoint**:
- [ ] Scene runs without errors
- [ ] Photons spawn from top (y=0) at 2 per second
- [ ] CO2 molecules spawn from left (x=0) at 3 per second
- [ ] H2O molecules spawn from bottom (y=720) at 3 per second
- [ ] Molecules despawn after 5 seconds automatically
- [ ] Molecule count stabilizes around 40-50 (spawn rate × despawn time × 3 spawners)
- [ ] All molecules can be dragged
- [ ] Performance stays smooth (60 FPS)

---

### Task 2.7: Workspace Area Detection
**Dependencies**: Task 2.6 (Spawner works)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/systems/Workspace.gd`:
   ```gdscript
   extends Area2D
   class_name Workspace
   
   signal molecule_entered(molecule: Molecule)
   signal molecule_exited(molecule: Molecule)
   signal capacity_reached()
   signal capacity_available()
   
   @export var capacity: int = 20
   @export var workspace_color: Color = Color.GREEN
   @export var full_color: Color = Color.RED
   
   var molecules_in_workspace: Array[Molecule] = []
   var is_full: bool = false
   
   func _ready() -> void:
   	# Configure collision
   	collision_layer = 4  # Layer 3 for workspace
   	collision_mask = 2   # Detect layer 2 (molecules)
   	monitoring = true
   	monitorable = false
   	
   	# Connect signals
   	area_entered.connect(_on_area_entered)
   	area_exited.connect(_on_area_exited)
   	
   	# Update visual
   	update_visual()
   
   func _on_area_entered(area: Area2D) -> void:
   	if area is Molecule:
   		var molecule = area as Molecule
   		
   		# Check if workspace is full
   		if molecules_in_workspace.size() >= capacity:
   			if not is_full:
   				is_full = true
   				capacity_reached.emit()
   				update_visual()
   			return
   		
   		# Add to workspace
   		if molecule not in molecules_in_workspace:
   			molecules_in_workspace.append(molecule)
   			molecule.current_state = Molecule.State.IN_WORKSPACE
   			molecule_entered.emit(molecule)
   			
   			# Check if now full
   			if molecules_in_workspace.size() >= capacity:
   				is_full = true
   				capacity_reached.emit()
   				update_visual()
   
   func _on_area_exited(area: Area2D) -> void:
   	if area is Molecule:
   		var molecule = area as Molecule
   		
   		if molecule in molecules_in_workspace:
   			molecules_in_workspace.erase(molecule)
   			if molecule.current_state == Molecule.State.IN_WORKSPACE:
   				molecule.current_state = Molecule.State.IDLE
   			molecule_exited.emit(molecule)
   			
   			# Check if no longer full
   			if is_full and molecules_in_workspace.size() < capacity:
   				is_full = false
   				capacity_available.emit()
   				update_visual()
   
   func get_molecule_count() -> int:
   	return molecules_in_workspace.size()
   
   func is_at_capacity() -> bool:
   	return is_full
   
   func update_visual() -> void:
   	# Update border color based on capacity
   	var border = get_node_or_null("Border")
   	if border and border is Line2D:
   		if is_full:
   			border.default_color = full_color
   		else:
   			border.default_color = workspace_color
   
   func clear_molecules() -> void:
   	"""Remove all molecules from workspace (for reset)."""
   	for molecule in molecules_in_workspace:
   		molecule.current_state = Molecule.State.IDLE
   	molecules_in_workspace.clear()
   	is_full = false
   	update_visual()
   ```

2. Use tabs, type hints
3. Save script

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Class name "Workspace" recognized
- [ ] All signals declared
- [ ] Capacity checking logic present
- [ ] Type hints on all variables and functions
- [ ] Indentation uses tabs

---

### Task 2.8: Workspace Scene - Stage 1 Chloroplast
**Dependencies**: Task 2.7 (Workspace script)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scenes/stages/WorkspaceStage1.tscn`:
   - Root: Area2D (attach Workspace.gd)
   - Name: "Workspace"
   - Position: (640, 360) - center of screen

2. Add child: CollisionShape2D
   - Shape: New CircleShape2D
   - CircleShape2D → Radius: 300 (from GameConstants.WORKSPACE_RADIUS_STAGE1)

3. Add child: Line2D (name: "Border")
   - Points: Create circle outline (16 points around radius 300)
   - Width: 5
   - Default Color: Green (#90EE90 with alpha 0.8)
   - Antialiased: true

4. Add child: Sprite2D (name: "BackgroundGlow")
   - Texture: Create GradientTexture2D
   - GradientTexture2D → Width: 600, Height: 600
   - Gradient: Green (#90EE90) at center to transparent at edges
   - Fill: Radial
   - Modulate → Alpha: 0.3 (subtle glow)

5. Configure Workspace properties in Inspector:
   - capacity: 20
   - workspace_color: #90EE90 (green)
   - full_color: #FF0000 (red)

6. Save scene

**Human Checkpoint**:
- [ ] Scene opens without errors
- [ ] Workspace shows as green circle (radius 300) at screen center
- [ ] Border is visible (5px green line)
- [ ] Background has subtle green glow
- [ ] Collision shape matches visual circle
- [ ] Can be instantiated in test scene

---

### Task 2.9: Workspace Testing with Capacity
**Dependencies**: Task 2.8 (Workspace scene), Task 2.6 (Spawner test scene)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open `res://scenes/test/TestSpawner.tscn`
2. Add Workspace instance:
   - Add child: Instance `WorkspaceStage1.tscn`
   - Position should be (640, 360) from scene

3. Update debug script to show workspace count:
   ```gdscript
   extends Node2D
   
   func _ready() -> void:
   	$Workspace.capacity_reached.connect(_on_workspace_full)
   	$Workspace.capacity_available.connect(_on_workspace_available)
   
   func _process(delta: float) -> void:
   	var total = 0
   	total += $PhotonSpawner.active_molecules.size()
   	total += $CO2Spawner.active_molecules.size()
   	total += $H2OSpawner.active_molecules.size()
   	
   	var in_workspace = $Workspace.get_molecule_count()
   	
   	$DebugLabel.text = "Total: %d | In Workspace: %d/20" % [total, in_workspace]
   	
   	if $Workspace.is_at_capacity():
   		$DebugLabel.modulate = Color.RED
   	else:
   		$DebugLabel.modulate = Color.WHITE
   
   func _on_workspace_full() -> void:
   	print("Workspace is full!")
   
   func _on_workspace_available() -> void:
   	print("Workspace has space available")
   ```

4. Run scene and test:
   - Drag molecules into workspace
   - Watch counter increase
   - Drag 20 molecules in
   - Border should turn red when full
   - Try dragging 21st molecule - should not enter

**Human Checkpoint**:
- [ ] Scene runs without errors
- [ ] Dragging molecules into green circle counts them
- [ ] Debug label shows "In Workspace: X/20"
- [ ] At 20 molecules, border turns red
- [ ] Cannot drag more molecules in when at capacity
- [ ] Dragging molecules out decreases count
- [ ] Border returns to green when below capacity
- [ ] Console prints "Workspace is full!" at 20

---

### Task 2.10: Trash Zone Implementation
**Dependencies**: Task 2.9 (Workspace works with capacity)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/systems/TrashZone.gd`:
   ```gdscript
   extends Area2D
   class_name TrashZone
   
   signal molecule_deleted(molecule: Molecule)
   
   var deletion_tween: Tween
   
   func _ready() -> void:
   	# Configure collision
   	collision_layer = 8  # Layer 4 for trash zone
   	collision_mask = 2   # Detect layer 2 (molecules)
   	monitoring = true
   	monitorable = false
   	
   	# Connect signals
   	area_entered.connect(_on_area_entered)
   
   func _on_area_entered(area: Area2D) -> void:
   	if area is Molecule:
   		var molecule = area as Molecule
   		
   		# Only delete if dropped (not dragging through)
   		if molecule.current_state == Molecule.State.IDLE:
   			delete_molecule(molecule)
   
   func delete_molecule(molecule: Molecule) -> void:
   	"""Play deletion animation and remove molecule."""
   	molecule_deleted.emit(molecule)
   	
   	# Create tween for deletion animation
   	if deletion_tween:
   		deletion_tween.kill()
   	
   	deletion_tween = create_tween()
   	deletion_tween.set_parallel(true)
   	
   	# Shrink to zero scale
   	deletion_tween.tween_property(
   		molecule, "scale",
   		Vector2.ZERO,
   		GameConstants.DELETION_ANIMATION_DURATION
   	)
   	
   	# Fade out
   	deletion_tween.tween_property(
   		molecule, "modulate:a",
   		0.0,
   		GameConstants.DELETION_ANIMATION_DURATION
   	)
   	
   	# Delete when animation complete
   	deletion_tween.finished.connect(func(): molecule.queue_free())
   ```

2. Use tabs, type hints
3. Save script

4. Create `res://scenes/systems/TrashZone.tscn`:
   - Root: Area2D (attach TrashZone.gd)
   - Name: "TrashZone"
   - Position: (1190, 660) - bottom-right corner

5. Add child: CollisionShape2D
   - Shape: New RectangleShape2D
   - RectangleShape2D → Size: (180, 120)

6. Add child: ColorRect (name: "Background")
   - Size: (180, 120)
   - Position: (-90, -60) - centered on parent
   - Color: #8B4513 (brown) with alpha 0.3

7. Add child: Sprite2D (name: "Icon")
   - For now, use simple TextureRect with "🗑️" text
   - Or: Create simple trash can icon with Line2D
   - Position: (0, 0)
   - Scale: (2, 2)

8. Add child: Line2D (name: "Border")
   - Points: Rectangle outline (5 points: corners + back to start)
   - Width: 3
   - Default Color: Red (#FF0000)

9. Save scene

**Human Checkpoint**:
- [ ] TrashZone.tscn opens without errors
- [ ] Trash zone visible in bottom-right corner
- [ ] Red border outlines the zone
- [ ] Script compiles without errors
- [ ] Can instantiate in test scene
- [ ] Molecules shrink and fade when dropped in zone (test after adding to scene)

---

### Task 2.11: Trash Zone Testing
**Dependencies**: Task 2.10 (TrashZone scene)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open `res://scenes/test/TestSpawner.tscn`
2. Add TrashZone instance:
   - Add child: Instance `TrashZone.tscn`
   - Position from scene should be (1190, 660)

3. Update debug script to track deletions:
   ```gdscript
   extends Node2D
   
   var molecules_deleted: int = 0
   
   func _ready() -> void:
   	$Workspace.capacity_reached.connect(_on_workspace_full)
   	$Workspace.capacity_available.connect(_on_workspace_available)
   	$TrashZone.molecule_deleted.connect(_on_molecule_deleted)
   
   func _process(delta: float) -> void:
   	var total = 0
   	total += $PhotonSpawner.active_molecules.size()
   	total += $CO2Spawner.active_molecules.size()
   	total += $H2OSpawner.active_molecules.size()
   	
   	var in_workspace = $Workspace.get_molecule_count()
   	
   	$DebugLabel.text = "Total: %d | In Workspace: %d/20 | Deleted: %d" % [total, in_workspace, molecules_deleted]
   	
   	if $Workspace.is_at_capacity():
   		$DebugLabel.modulate = Color.RED
   	else:
   		$DebugLabel.modulate = Color.WHITE
   
   func _on_workspace_full() -> void:
   	print("Workspace is full!")
   
   func _on_workspace_available() -> void:
   	print("Workspace has space available")
   
   func _on_molecule_deleted(molecule: Molecule) -> void:
   	molecules_deleted += 1
   	print("Molecule deleted! Total: ", molecules_deleted)
   ```

4. Run scene (F6) and test:
   - Drag molecules to trash zone in bottom-right
   - Watch deletion animation (shrink + fade)
   - Check that counter increments

**Human Checkpoint**:
- [ ] Scene runs without errors
- [ ] Trash zone visible in bottom-right corner (red border)
- [ ] Dragging molecules into trash zone triggers deletion
- [ ] Deletion animation plays (0.3s shrink + fade)
- [ ] Debug label shows "Deleted: X" counter
- [ ] Console prints "Molecule deleted!" message
- [ ] Molecules actually disappear after animation

---

### Task 2.12: Molecule Separation Force
**Dependencies**: Task 2.11 (All basic systems work)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open `res://scripts/molecules/Molecule.gd`
2. Add separation force calculation to `_process_idle()` and `_process_in_workspace()`:
   ```gdscript
   func _process_idle(delta: float) -> void:
   	time_since_spawn += delta
   	if time_since_spawn >= GameConstants.MOLECULE_DESPAWN_TIME:
   		despawn()
   	
   	# Apply separation force
   	apply_separation_force(delta)
   
   func _process_in_workspace(delta: float) -> void:
   	# Apply separation force
   	apply_separation_force(delta)
   
   func apply_separation_force(delta: float) -> void:
   	"""Push away from nearby molecules to prevent overlap."""
   	var separation_velocity = Vector2.ZERO
   	var nearby_count = 0
   	
   	# Get all overlapping areas
   	var overlapping = get_overlapping_areas()
   	for area in overlapping:
   		if area is Molecule and area != self:
   			# Calculate direction away from other molecule
   			var direction = global_position - area.global_position
   			var distance = direction.length()
   			
   			# Only separate if very close
   			if distance < GameConstants.MOLECULE_COLLISION_RADIUS * 2:
   				if distance > 0:
   					direction = direction.normalized()
   					# Closer = stronger push
   					var strength = 1.0 - (distance / (GameConstants.MOLECULE_COLLISION_RADIUS * 2))
   					separation_velocity += direction * strength
   					nearby_count += 1
   	
   	# Apply average separation
   	if nearby_count > 0:
   		separation_velocity = separation_velocity / nearby_count
   		separation_velocity *= GameConstants.MOLECULE_SEPARATION_FORCE
   		global_position += separation_velocity * delta
   ```

3. Save script

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Run TestSpawner scene
- [ ] Molecules that spawn overlapping gradually separate
- [ ] Separation is smooth (not jittery)
- [ ] Molecules in workspace also separate from each other
- [ ] Separation force doesn't push molecules too far (stays within workspace)

---

## PHASE 2 COMPLETION VERIFICATION

Before proceeding to Phase 3, verify:

### Molecule System
- [ ] Base Molecule class works with dragging
- [ ] All 5 molecule types exist (Photon, CO2, H2O, O2, Glucose)
- [ ] Molecules can be dragged and dropped
- [ ] Hover feedback (white outline) works
- [ ] Drag cooldown (0.2s) prevents spam

### Spawning System
- [ ] MoleculeSpawner creates molecules at correct rates
- [ ] Object pooling reuses molecules (no instantiate spam)
- [ ] Molecules despawn after 5 seconds automatically
- [ ] Max molecule cap enforced (30 for Stage 1)
- [ ] Spawn zones have random offsets

### Workspace System
- [ ] Workspace detects molecules entering
- [ ] Capacity limit enforced (20 for Stage 1)
- [ ] Border color changes when full (green → red)
- [ ] Molecules can be removed from workspace
- [ ] Capacity tracking accurate

### Trash Zone
- [ ] Trash zone in bottom-right corner
- [ ] Deletion animation plays (shrink + fade, 0.3s)
- [ ] Molecules removed from scene after deletion
- [ ] Counter tracks deleted molecules

### Polish
- [ ] Separation force prevents molecule overlap
- [ ] Performance stable (60 FPS with 50+ molecules)
- [ ] No memory leaks over 5-minute session

---


## PHASE 3: Reaction System (Stages 1 & 2)

**Phase Goal**: Implement chemical reaction detection and visual effects  
**Duration**: 2-3 weeks  
**MVP Status**: Pre-MVP to MVP Transition

---

### Task 3.1: Reaction Handler - Detection Logic
**Dependencies**: Phase 2 Complete (Workspace with molecules)  
**Extended thinking**: ON  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **ON**."

**Implementation**:
1. Create `res://scripts/systems/ReactionHandler.gd`:
   ```gdscript
   extends Node
   class_name ReactionHandler
   
   enum ReactionType {PHOTOSYNTHESIS, RESPIRATION}
   
   signal reaction_triggered(type: ReactionType, input_molecules: Array[Molecule], output_info: Dictionary)
   
   @export var workspace: Workspace
   @export var reaction_type: ReactionType = ReactionType.PHOTOSYNTHESIS
   @export var enabled: bool = true
   
   # Tracking
   var reaction_cooldown: float = 0.0
   const REACTION_COOLDOWN_TIME: float = 0.1  # Prevent double-triggers
   
   func _ready() -> void:
   	if not workspace:
   		push_error("ReactionHandler requires a Workspace reference")
   		return
   	
   	# Connect to workspace signals
   	workspace.molecule_entered.connect(_check_reaction_conditions)
   	workspace.molecule_exited.connect(_check_reaction_conditions.unbind(1))
   
   func _process(delta: float) -> void:
   	if reaction_cooldown > 0:
   		reaction_cooldown -= delta
   
   func _check_reaction_conditions(_molecule: Molecule = null) -> void:
   	"""Check if reaction requirements are met."""
   	if not enabled or reaction_cooldown > 0:
   		return
   	
   	match reaction_type:
   		ReactionType.PHOTOSYNTHESIS:
   			_check_photosynthesis()
   		ReactionType.RESPIRATION:
   			_check_respiration()
   
   func _check_photosynthesis() -> void:
   	"""Check for: 6 CO2 + 6 H2O + 12 photons → glucose + 6 O2."""
   	var co2_count = 0
   	var h2o_count = 0
   	var photon_count = 0
   	
   	var co2_molecules: Array[Molecule] = []
   	var h2o_molecules: Array[Molecule] = []
   	var photon_molecules: Array[Molecule] = []
   	
   	# Count molecules, excluding those being dragged
   	for molecule in workspace.molecules_in_workspace:
   		if molecule.current_state == Molecule.State.BEING_DRAGGED:
   			continue
   		
   		match molecule.molecule_type:
   			Molecule.MoleculeType.CO2:
   				co2_count += 1
   				co2_molecules.append(molecule)
   			Molecule.MoleculeType.H2O:
   				h2o_count += 1
   				h2o_molecules.append(molecule)
   			Molecule.MoleculeType.PHOTON:
   				photon_count += 1
   				photon_molecules.append(molecule)
   	
   	# Check if requirements met
   	if (co2_count >= GameConstants.PHOTOSYNTHESIS_CO2_NEEDED and
   		h2o_count >= GameConstants.PHOTOSYNTHESIS_H2O_NEEDED and
   		photon_count >= GameConstants.PHOTOSYNTHESIS_PHOTONS_NEEDED):
   		
   		# Collect exact number needed
   		var input_molecules: Array[Molecule] = []
   		input_molecules.append_array(co2_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_CO2_NEEDED))
   		input_molecules.append_array(h2o_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_H2O_NEEDED))
   		input_molecules.append_array(photon_molecules.slice(0, GameConstants.PHOTOSYNTHESIS_PHOTONS_NEEDED))
   		
   		# Prepare output info
   		var output_info = {
   			"glucose_count": GameConstants.PHOTOSYNTHESIS_GLUCOSE_PRODUCED,
   			"o2_count": GameConstants.PHOTOSYNTHESIS_O2_PRODUCED
   		}
   		
   		# Trigger reaction
   		trigger_reaction(ReactionType.PHOTOSYNTHESIS, input_molecules, output_info)
   
   func _check_respiration() -> void:
   	"""Check for: 1 glucose + 6 O2 → 6 CO2 + 6 H2O + ATP."""
   	var glucose_count = 0
   	var o2_count = 0
   	
   	var glucose_molecules: Array[Molecule] = []
   	var o2_molecules: Array[Molecule] = []
   	
   	# Count molecules, excluding those being dragged
   	for molecule in workspace.molecules_in_workspace:
   		if molecule.current_state == Molecule.State.BEING_DRAGGED:
   			continue
   		
   		match molecule.molecule_type:
   			Molecule.MoleculeType.GLUCOSE:
   				glucose_count += 1
   				glucose_molecules.append(molecule)
   			Molecule.MoleculeType.O2:
   				o2_count += 1
   				o2_molecules.append(molecule)
   	
   	# Check if requirements met
   	if (glucose_count >= GameConstants.RESPIRATION_GLUCOSE_NEEDED and
   		o2_count >= GameConstants.RESPIRATION_O2_NEEDED):
   		
   		# Collect exact number needed
   		var input_molecules: Array[Molecule] = []
   		input_molecules.append_array(glucose_molecules.slice(0, GameConstants.RESPIRATION_GLUCOSE_NEEDED))
   		input_molecules.append_array(o2_molecules.slice(0, GameConstants.RESPIRATION_O2_NEEDED))
   		
   		# Prepare output info
   		var output_info = {
   			"co2_count": GameConstants.RESPIRATION_CO2_PRODUCED,
   			"h2o_count": GameConstants.RESPIRATION_H2O_PRODUCED,
   			"atp_count": GameConstants.RESPIRATION_ATP_PRODUCED
   		}
   		
   		# Trigger reaction
   		trigger_reaction(ReactionType.RESPIRATION, input_molecules, output_info)
   
   func trigger_reaction(type: ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
   	"""Emit reaction signal and set cooldown."""
   	reaction_cooldown = REACTION_COOLDOWN_TIME
   	reaction_triggered.emit(type, input_molecules, output_info)
   ```

2. Use tabs, type hints throughout
3. Save script

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Class name "ReactionHandler" recognized
- [ ] Detection logic accounts for dragged molecules (excludes them)
- [ ] Uses GameConstants for all reaction requirements
- [ ] Signal emits with input molecules and output info
- [ ] Cooldown prevents double-triggers
- [ ] Type hints present, tabs used

---

### Task 3.2: Reaction Effect - Visual Animation
**Dependencies**: Task 3.1 (Reaction detection)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/effects/ReactionEffect.gd`:
   ```gdscript
   extends Node2D
   class_name ReactionEffect
   
   @export var effect_color: Color = Color.GREEN
   @export var duration: float = 0.8
   
   signal animation_complete()
   
   func _ready() -> void:
   	visible = false
   
   func play_reaction(center_pos: Vector2, input_molecules: Array[Molecule]) -> void:
   	"""Animate molecules swirling into center and disappearing."""
   	visible = true
   	global_position = center_pos
   	
   	# Create tween for swirl animation
   	var tween = create_tween()
   	tween.set_parallel(true)
   	
   	# Animate each input molecule
   	for molecule in input_molecules:
   		# Swirl to center
   		tween.tween_property(
   			molecule, "global_position",
   			center_pos,
   			duration
   		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
   		
   		# Scale down
   		tween.tween_property(
   			molecule, "scale",
   			Vector2.ZERO,
   			duration
   		).set_ease(Tween.EASE_IN)
   	
   	# Flash effect at center
   	tween.tween_callback(_flash_center.bind(center_pos))
   	
   	# Clean up molecules after animation
   	tween.finished.connect(func():
   		for molecule in input_molecules:
   			molecule.queue_free()
   		animation_complete.emit()
   		visible = false
   	)
   
   func _flash_center(center_pos: Vector2) -> void:
   	"""Create visual flash at reaction center."""
   	# Create flash sprite
   	var flash = Sprite2D.new()
   	get_tree().current_scene.add_child(flash)
   	flash.global_position = center_pos
   	
   	# Create circular gradient texture
   	var gradient_texture = GradientTexture2D.new()
   	gradient_texture.width = 200
   	gradient_texture.height = 200
   	gradient_texture.fill = GradientTexture2D.FILL_RADIAL
   	
   	var gradient = Gradient.new()
   	gradient.set_color(0, effect_color)
   	gradient.set_color(1, Color(effect_color, 0))  # Transparent at edges
   	gradient_texture.gradient = gradient
   	
   	flash.texture = gradient_texture
   	
   	# Animate flash
   	var flash_tween = create_tween()
   	flash_tween.tween_property(flash, "scale", Vector2(3, 3), 0.3)
   	flash_tween.parallel().tween_property(flash, "modulate:a", 0.0, 0.3)
   	flash_tween.finished.connect(func(): flash.queue_free())
   ```

2. Use tabs, type hints
3. Save script

4. Create `res://scenes/effects/ReactionEffect.tscn`:
   - Root: Node2D (attach ReactionEffect.gd)
   - Name: "ReactionEffect"
   - Configure properties:
	 - effect_color: #90EE90 (green for photosynthesis)
	 - duration: 0.8

5. Save scene

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Scene opens without errors
- [ ] Class name "ReactionEffect" recognized
- [ ] Tween animations defined (swirl, scale, flash)
- [ ] Flash effect creates temporary sprite with gradient
- [ ] Type hints present, tabs used

---

### Task 3.3: Reaction Integration Testing
**Dependencies**: Task 3.2 (Reaction effect animation)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open `res://scenes/test/TestSpawner.tscn`
2. Add ReactionHandler:
   - Add child to root: Node (attach ReactionHandler.gd)
   - Name: "ReactionHandler"
   - Configure in Inspector:
	 - workspace: Drag reference to Workspace node
	 - reaction_type: PHOTOSYNTHESIS
	 - enabled: true

3. Add ReactionEffect:
   - Add child to root: Instance `ReactionEffect.tscn`
   - Configure:
	 - effect_color: #90EE90 (green)
	 - duration: 0.8

4. Update test script to connect reaction signals:
   ```gdscript
   extends Node2D
   
   var molecules_deleted: int = 0
   var reactions_occurred: int = 0
   
   func _ready() -> void:
   	$Workspace.capacity_reached.connect(_on_workspace_full)
   	$Workspace.capacity_available.connect(_on_workspace_available)
   	$TrashZone.molecule_deleted.connect(_on_molecule_deleted)
   	$ReactionHandler.reaction_triggered.connect(_on_reaction_triggered)
   	$ReactionEffect.animation_complete.connect(_on_reaction_complete)
   
   func _process(delta: float) -> void:
   	var total = 0
   	total += $PhotonSpawner.active_molecules.size()
   	total += $CO2Spawner.active_molecules.size()
   	total += $H2OSpawner.active_molecules.size()
   	
   	var in_workspace = $Workspace.get_molecule_count()
   	
   	$DebugLabel.text = "Total: %d | Workspace: %d/20 | Deleted: %d | Reactions: %d" % [
   		total, in_workspace, molecules_deleted, reactions_occurred
   	]
   	
   	if $Workspace.is_at_capacity():
   		$DebugLabel.modulate = Color.RED
   	else:
   		$DebugLabel.modulate = Color.WHITE
   
   func _on_workspace_full() -> void:
   	print("Workspace is full!")
   
   func _on_workspace_available() -> void:
   	print("Workspace has space available")
   
   func _on_molecule_deleted(molecule: Molecule) -> void:
   	molecules_deleted += 1
   
   func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array, output_info: Dictionary) -> void:
   	print("Reaction triggered! Type: ", type, " Inputs: ", input_molecules.size())
   	reactions_occurred += 1
   	
   	# Play animation
   	$ReactionEffect.play_reaction($Workspace.global_position, input_molecules)
   
   func _on_reaction_complete() -> void:
   	print("Reaction animation complete")
   	
   	# TODO: Spawn output molecules (glucose, O2)
   ```

5. Run scene and test:
   - Drag 6 CO2, 6 H2O, and 12 photons into workspace
   - Watch for reaction to trigger
   - Observe swirl animation

**Human Checkpoint**:
- [ ] Scene runs without errors
- [ ] Dragging correct molecules triggers reaction
- [ ] Console prints "Reaction triggered!" with molecule count
- [ ] Molecules swirl toward workspace center (0.8s animation)
- [ ] Molecules scale down to zero during swirl
- [ ] Green flash appears at center
- [ ] Input molecules disappear after animation
- [ ] Reaction counter increments in debug label
- [ ] Console prints "Reaction animation complete"

---

### Task 3.4: Output Molecule Spawning
**Dependencies**: Task 3.3 (Reaction triggers and animates)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Update `res://scripts/effects/ReactionEffect.gd` to spawn output molecules:
   ```gdscript
   signal spawn_outputs(output_info: Dictionary, center_pos: Vector2)
   
   func play_reaction(center_pos: Vector2, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
   	"""Animate molecules swirling into center and spawn outputs."""
   	visible = true
   	global_position = center_pos
   	
   	# Create tween for swirl animation
   	var tween = create_tween()
   	tween.set_parallel(true)
   	
   	# Animate each input molecule (existing code...)
   	for molecule in input_molecules:
   		tween.tween_property(
   			molecule, "global_position",
   			center_pos,
   			duration
   		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
   		
   		tween.tween_property(
   			molecule, "scale",
   			Vector2.ZERO,
   			duration
   		).set_ease(Tween.EASE_IN)
   	
   	# Flash effect at center
   	tween.tween_callback(_flash_center.bind(center_pos))
   	
   	# Spawn outputs after flash
   	tween.tween_callback(func():
   		spawn_outputs.emit(output_info, center_pos)
   	).set_delay(0.2)
   	
   	# Clean up molecules after animation (existing code...)
   	tween.finished.connect(func():
   		for molecule in input_molecules:
   			molecule.queue_free()
   		animation_complete.emit()
   		visible = false
   	)
   ```

2. Create `res://scripts/systems/OutputSpawner.gd`:
   ```gdscript
   extends Node
   class_name OutputSpawner
   
   @export var glucose_scene: PackedScene
   @export var o2_scene: PackedScene
   @export var co2_scene: PackedScene
   @export var h2o_scene: PackedScene
   
   func spawn_photosynthesis_outputs(center_pos: Vector2) -> void:
   	"""Spawn 1 glucose and 6 O2."""
   	# Spawn glucose at center
   	if glucose_scene:
   		var glucose = glucose_scene.instantiate() as Molecule
   		get_tree().current_scene.add_child(glucose)
   		glucose.global_position = center_pos
   		glucose.scale = Vector2.ZERO
   		
   		# Animate scale up
   		var tween = create_tween()
   		tween.tween_property(
   			glucose, "scale",
   			Vector2(1, 1),
   			GameConstants.REACTION_SCALE_DURATION
   		)
   	
   	# Spawn O2 molecules in circle around center
   	if o2_scene:
   		for i in range(GameConstants.PHOTOSYNTHESIS_O2_PRODUCED):
   			var o2 = o2_scene.instantiate() as Molecule
   			get_tree().current_scene.add_child(o2)
   			o2.global_position = center_pos
   			o2.scale = Vector2.ZERO
   			
   			# Calculate position in circle
   			var angle = (TAU / GameConstants.PHOTOSYNTHESIS_O2_PRODUCED) * i
   			var target_pos = center_pos + Vector2(cos(angle), sin(angle)) * 100
   			
   			# Animate scale up and drift away
   			var tween = create_tween()
   			tween.tween_property(
   				o2, "scale",
   				Vector2(1, 1),
   				GameConstants.REACTION_SCALE_DURATION
   			)
   			tween.parallel().tween_property(
   				o2, "global_position",
   				target_pos,
   				GameConstants.O2_DRIFT_DURATION
   			).set_ease(Tween.EASE_OUT)
   	
   	# Update GameManager
   	GameManager.increment_glucose_created()
   
   func spawn_respiration_outputs(center_pos: Vector2) -> void:
   	"""Spawn 6 CO2, 6 H2O, and 3 ATP bolts."""
   	# Spawn CO2 molecules
   	if co2_scene:
   		for i in range(GameConstants.RESPIRATION_CO2_PRODUCED):
   			var co2 = co2_scene.instantiate() as Molecule
   			get_tree().current_scene.add_child(co2)
   			
   			var angle = (TAU / GameConstants.RESPIRATION_CO2_PRODUCED) * i
   			var target_pos = center_pos + Vector2(cos(angle), sin(angle)) * 100
   			
   			co2.global_position = center_pos
   			co2.scale = Vector2.ZERO
   			
   			var tween = create_tween()
   			tween.tween_property(co2, "scale", Vector2(1, 1), GameConstants.REACTION_SCALE_DURATION)
   			tween.parallel().tween_property(co2, "global_position", target_pos, GameConstants.O2_DRIFT_DURATION).set_ease(Tween.EASE_OUT)
   	
   	# Spawn H2O molecules
   	if h2o_scene:
   		for i in range(GameConstants.RESPIRATION_H2O_PRODUCED):
   			var h2o = h2o_scene.instantiate() as Molecule
   			get_tree().current_scene.add_child(h2o)
   			
   			var angle = (TAU / GameConstants.RESPIRATION_H2O_PRODUCED) * i + (TAU / 12)  # Offset from CO2
   			var target_pos = center_pos + Vector2(cos(angle), sin(angle)) * 80
   			
   			h2o.global_position = center_pos
   			h2o.scale = Vector2.ZERO
   			
   			var tween = create_tween()
   			tween.tween_property(h2o, "scale", Vector2(1, 1), GameConstants.REACTION_SCALE_DURATION)
   			tween.parallel().tween_property(h2o, "global_position", target_pos, GameConstants.O2_DRIFT_DURATION).set_ease(Tween.EASE_OUT)
   	
   	# TODO: Spawn ATP bolts (Task 3.5)
   	
   	# Update GameManager
   	GameManager.increment_glucose_broken()
   ```

3. Use tabs, type hints
4. Save both scripts

**Human Checkpoint**:
- [ ] Scripts compile without errors
- [ ] Class name "OutputSpawner" recognized
- [ ] spawn_photosynthesis_outputs() spawns 1 glucose + 6 O2
- [ ] Output molecules scale up from zero (0.3s)
- [ ] O2 molecules drift outward in circle pattern (2s)
- [ ] GameManager signals fire (glucose_created_updated)
- [ ] Type hints present, tabs used

---

### Task 3.5: ATP Bolt Visualization
**Dependencies**: Task 3.4 (Output spawning works)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/effects/ATPBolt.gd`:
   ```gdscript
   extends Line2D
   class_name ATPBolt
   
   var lifetime: float = 0.0
   var max_lifetime: float = GameConstants.ATP_BOLT_DURATION
   
   func _ready() -> void:
   	# Configure line appearance
   	width = 5
   	default_color = Color.YELLOW
   	antialiased = true
   	
   	# Create lightning bolt shape
   	points = generate_bolt_points()
   
   func _process(delta: float) -> void:
   	lifetime += delta
   	
   	# Fade out
   	var alpha = 1.0 - (lifetime / max_lifetime)
   	default_color = Color(1, 1, 0, alpha)  # Yellow with fading alpha
   	
   	# Delete when done
   	if lifetime >= max_lifetime:
   		queue_free()
   
   func generate_bolt_points() -> PackedVector2Array:
   	"""Generate lightning bolt line points."""
   	var pts: PackedVector2Array = []
   	var length = GameConstants.ATP_BOLT_LENGTH
   	
   	# Start at origin
   	pts.append(Vector2.ZERO)
   	
   	# Create zigzag pattern
   	var segments = 4
   	for i in range(segments):
   		var progress = float(i + 1) / segments
   		var base_pos = Vector2(length * progress, 0)
   		
   		# Add random offset perpendicular to direction
   		var offset = Vector2(0, randf_range(-20, 20))
   		pts.append(base_pos + offset)
   	
   	return pts
   
   func set_direction(angle_degrees: float) -> void:
   	"""Rotate the bolt to point in a direction."""
   	rotation_degrees = angle_degrees
   ```

2. Use tabs, type hints
3. Save script

4. Create `res://scenes/effects/ATPBolt.tscn`:
   - Root: Line2D (attach ATPBolt.gd)
   - Name: "ATPBolt"
   - Configure in Inspector:
	 - Width: 5
	 - Default Color: Yellow (#FFFF00)

5. Save scene

6. Update OutputSpawner to spawn ATP bolts:
   ```gdscript
   func spawn_respiration_outputs(center_pos: Vector2) -> void:
   	"""Spawn 6 CO2, 6 H2O, and 3 ATP bolts."""
   	# ... existing CO2 and H2O spawning code ...
   	
   	# Spawn ATP bolts
   	var atp_bolt_scene = preload("res://scenes/effects/ATPBolt.tscn")
   	for i in range(GameConstants.RESPIRATION_ATP_PRODUCED):
   		var bolt = atp_bolt_scene.instantiate() as ATPBolt
   		get_tree().current_scene.add_child(bolt)
   		bolt.global_position = center_pos
   		
   		# Set direction (120° apart for 3 bolts)
   		var angle = (360.0 / GameConstants.RESPIRATION_ATP_PRODUCED) * i
   		bolt.set_direction(angle)
   	
   	# Update GameManager
   	GameManager.increment_glucose_broken()
   ```

7. Save OutputSpawner.gd

**Human Checkpoint**:
- [ ] ATPBolt script compiles without errors
- [ ] ATPBolt scene opens without errors
- [ ] Lightning bolt shape generates (zigzag line)
- [ ] Bolts fade out over 0.5 seconds
- [ ] Three bolts spawn at 120° intervals (0°, 120°, 240°)
- [ ] Bolts appear at mitochondria center (when respiration occurs)
- [ ] Bolts delete themselves after fading

---

### Task 3.6: Workspace Background Pulse Effect
**Dependencies**: Task 3.5 (All reaction visuals work)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Open `res://scripts/systems/Workspace.gd`
2. Add background pulsing for reactions:
   ```gdscript
   var pulse_tween: Tween
   
   func pulse_reaction(reaction_color: Color) -> void:
   	"""Pulse background glow on reaction."""
   	var background = get_node_or_null("BackgroundGlow")
   	if not background:
   		return
   	
   	# Kill existing tween
   	if pulse_tween:
   		pulse_tween.kill()
   	
   	# Create new pulse
   	pulse_tween = create_tween()
   	
   	# Pulse opacity and color
   	pulse_tween.tween_property(
   		background, "modulate",
   		Color(reaction_color, 0.8),  # Bright
   		0.2
   	)
   	pulse_tween.tween_property(
   		background, "modulate",
   		Color(workspace_color, 0.3),  # Back to normal
   		0.6
   	)
   ```

3. Add idle pulse animation in `_ready()`:
   ```gdscript
   func _ready() -> void:
   	# ... existing code ...
   	
   	# Start idle pulse
   	start_idle_pulse()
   
   func start_idle_pulse() -> void:
   	"""Subtle breathing animation when idle."""
   	var background = get_node_or_null("BackgroundGlow")
   	if not background:
   		return
   	
   	var idle_tween = create_tween()
   	idle_tween.set_loops()  # Loop forever
   	
   	# Breathe in/out
   	idle_tween.tween_property(
   		background, "modulate:a",
   		0.4,  # Slightly brighter
   		1.0  # Over 1 second
   	).set_ease(Tween.EASE_IN_OUT)
   	
   	idle_tween.tween_property(
   		background, "modulate:a",
   		0.2,  # Dimmer
   		1.0
   	).set_ease(Tween.EASE_IN_OUT)
   ```

4. Save script

5. Update test scene to trigger pulse on reaction:
   ```gdscript
   func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array, output_info: Dictionary) -> void:
   	print("Reaction triggered! Type: ", type)
   	reactions_occurred += 1
   	
   	# Pulse workspace
   	var pulse_color = Color.GREEN if type == ReactionHandler.ReactionType.PHOTOSYNTHESIS else Color.ORANGE
   	$Workspace.pulse_reaction(pulse_color)
   	
   	# Play animation
   	$ReactionEffect.play_reaction($Workspace.global_position, input_molecules, output_info)
   ```

**Human Checkpoint**:
- [ ] Workspace background has subtle idle pulse (breathing effect)
- [ ] Pulse cycles smoothly (1s in, 1s out, loops forever)
- [ ] On reaction, background flashes bright (0.2s)
- [ ] Background returns to idle pulse after flash (0.6s)
- [ ] Green flash for photosynthesis (when implemented)
- [ ] Orange flash for respiration (when implemented)

---

### Task 3.7: Sound Effects Integration
**Dependencies**: Task 3.6 (All visual effects work)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create placeholder sound files OR note that we'll use Godot's built-in AudioStreamGenerator for now:

2. Create `res://scripts/systems/AudioManager.gd`:
   ```gdscript
   extends Node
   class_name AudioManager
   
   # Sound effect players
   var sfx_players: Array[AudioStreamPlayer] = []
   var sfx_pool_size: int = 8
   
   # Sound types (using simple sine tones for placeholders)
   enum SoundType {
   	MOLECULE_PICKUP,
   	MOLECULE_DROP,
   	REACTION_PHOTOSYNTHESIS,
   	REACTION_RESPIRATION,
   	WORKSPACE_FULL,
   	DELETE
   }
   
   func _ready() -> void:
   	# Create pool of audio players
   	for i in range(sfx_pool_size):
   		var player = AudioStreamPlayer.new()
   		add_child(player)
   		player.bus = "SFX"
   		sfx_players.append(player)
   
   func play_sound(sound_type: SoundType) -> void:
   	"""Play a sound effect using next available player."""
   	var player = get_available_player()
   	if not player:
   		return
   	
   	# Generate simple tone (placeholder until real sounds)
   	var stream = generate_tone(sound_type)
   	player.stream = stream
   	player.play()
   
   func get_available_player() -> AudioStreamPlayer:
   	"""Find a player that's not currently playing."""
   	for player in sfx_players:
   		if not player.playing:
   			return player
   	return sfx_players[0]  # Fallback to first player
   
   func generate_tone(sound_type: SoundType) -> AudioStreamGenerator:
   	"""Generate placeholder sine tone for each sound type."""
   	# For now, just return null - we'll add real sounds later
   	# TODO: Source real sound effects from Pixabay
   	return null
   ```

3. For now, add simple print statements as audio placeholders:
   ```gdscript
   func play_sound(sound_type: SoundType) -> void:
   	"""Play a sound effect (placeholder)."""
   	match sound_type:
   		SoundType.MOLECULE_PICKUP:
   			print("🔊 Boop!")
   		SoundType.MOLECULE_DROP:
   			print("🔊 Click!")
   		SoundType.REACTION_PHOTOSYNTHESIS:
   			print("🔊 Chime! ✨")
   		SoundType.REACTION_RESPIRATION:
   			print("🔊 Whoosh! 💨")
   		SoundType.WORKSPACE_FULL:
   			print("🔊 Buzz!")
   		SoundType.DELETE:
   			print("🔊 Pop!")
   	
   	# TODO: Replace with actual sound playback when audio files sourced
   ```

4. Use tabs, type hints
5. Save script
6. Configure as AutoLoad singleton

**Human Checkpoint**:
- [ ] AudioManager script compiles
- [ ] "AudioManager" in Project → Project Settings → Autoload
- [ ] play_sound() prints placeholder messages
- [ ] SFX audio player pool created (8 players)
- [ ] Bus set to "SFX" (create bus if needed: Audio → Audio Buses)
- [ ] Ready for real sound files in Phase 7

---

### Task 3.8: Camera Shake Effect
**Dependencies**: Task 3.7 (Audio system ready)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Update main test scene to have Camera2D:
   - Open test scene
   - Add child to root: Camera2D (name: "Camera")
   - Position: (640, 360)
   - Enabled: true
   - Anchor Mode: Fixed TopLeft

2. Create `res://scripts/effects/CameraShake.gd`:
   ```gdscript
   extends Node
   class_name CameraShake
   
   @export var camera: Camera2D
   @export var shake_amount: float = 5.0
   @export var shake_duration: float = 0.2
   
   var shake_tween: Tween
   var original_offset: Vector2 = Vector2.ZERO
   
   func _ready() -> void:
   	if camera:
   		original_offset = camera.offset
   
   func shake() -> void:
   	"""Shake the camera briefly."""
   	if not camera:
   		return
   	
   	# Kill existing shake
   	if shake_tween:
   		shake_tween.kill()
   	
   	# Reset to original
   	camera.offset = original_offset
   	
   	# Create shake tween
   	shake_tween = create_tween()
   	
   	# Shake in random directions
   	var shake_steps = 4
   	for i in range(shake_steps):
   		var random_offset = Vector2(
   			randf_range(-shake_amount, shake_amount),
   			randf_range(-shake_amount, shake_amount)
   		)
   		shake_tween.tween_property(
   			camera, "offset",
   			random_offset,
   			shake_duration / shake_steps
   		)
   	
   	# Return to original
   	shake_tween.tween_property(
   		camera, "offset",
   		original_offset,
   		shake_duration / shake_steps
   	)
   ```

3. Use tabs, type hints
4. Save script

5. Add CameraShake to test scene:
   - Add child: Node (attach CameraShake.gd)
   - Name: "CameraShake"
   - Configure:
     - camera: Drag reference to Camera2D
     - shake_amount: 5.0
     - shake_duration: 0.2

6. Update test script to shake on reaction:
   ```gdscript
   func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array, output_info: Dictionary) -> void:
   	print("Reaction triggered!")
   	reactions_occurred += 1
   	
   	# Effects
   	var pulse_color = Color.GREEN if type == ReactionHandler.ReactionType.PHOTOSYNTHESIS else Color.ORANGE
   	$Workspace.pulse_reaction(pulse_color)
   	$CameraShake.shake()
   	AudioManager.play_sound(
   		AudioManager.SoundType.REACTION_PHOTOSYNTHESIS if type == ReactionHandler.ReactionType.PHOTOSYNTHESIS
   		else AudioManager.SoundType.REACTION_RESPIRATION
   	)
   	
   	# Animation
   	$ReactionEffect.play_reaction($Workspace.global_position, input_molecules, output_info)
   ```

**Human Checkpoint**:
- [ ] Camera2D added to test scene
- [ ] CameraShake script compiles
- [ ] On reaction, camera shakes briefly (0.2s, 5px amplitude)
- [ ] Shake is subtle (not nauseating)
- [ ] Camera returns to original position after shake
- [ ] Multiple reactions don't cause cumulative shake

---

## PHASE 3 COMPLETION VERIFICATION

Before proceeding to Phase 4, verify:

### Reaction Detection
- [ ] ReactionHandler detects correct molecule counts
- [ ] Excludes dragged molecules from detection
- [ ] Uses GameConstants for all requirements
- [ ] Cooldown prevents double-triggers
- [ ] Works for both photosynthesis and respiration

### Visual Effects
- [ ] Input molecules swirl toward center (0.8s)
- [ ] Molecules scale down to zero during swirl
- [ ] Flash effect appears at center
- [ ] Workspace background pulses (green/orange)
- [ ] Idle pulse animation loops smoothly

### Output Spawning
- [ ] Glucose spawns at center (photosynthesis)
- [ ] O2 molecules drift outward in circle (6 total)
- [ ] CO2 and H2O spawn (respiration)
- [ ] ATP bolts shoot out at 120° intervals (3 total)
- [ ] Output molecules scale up from zero (0.3s)

### Polish
- [ ] Camera shakes on reaction (5px, 0.2s)
- [ ] Audio placeholders print to console
- [ ] All animations smooth (no jitter)
- [ ] GameManager counters increment
- [ ] Performance stable during reactions

---

## PHASE 4: Stages 1 & 2 Implementation

**Phase Goal**: Complete playable Stages 1 and 2 with HUD and progression  
**Duration**: 2-3 weeks  
**MVP Status**: Pre-MVP

---

### Task 4.1: Stage 1 Scene Assembly
**Dependencies**: Phase 3 Complete (Reactions work)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scenes/stages/Stage1_Photosynthesis.tscn`:
   - Root: Node2D (name: "Stage1")

2. Add background:
   - Add child: ColorRect (name: "Sky")
	 - Anchor: Full Rect
	 - Color: #87CEEB (light blue)
   
   - Add child: ColorRect (name: "Soil")
	 - Anchor: Bottom
	 - Size: 1280×200
	 - Position: (0, 520)
	 - Color: #8B4513 (brown)

3. Add sun rays (simple visual):
   - Add child: Line2D (name: "SunRay1")
	 - Points: [(0,0), (640, 360)] - diagonal from top-left
	 - Width: 20
	 - Default Color: #FFFF00 with alpha 0.2 (transparent yellow)
   - Duplicate for more rays (3-4 total, different angles)

4. Add core systems:
   - Instance `WorkspaceStage1.tscn` (chloroplast at center)
   - Add Node2D children for spawners:
	 - PhotonSpawner (configured for Stage 1)
	 - CO2Spawner (configured for Stage 1)
	 - H2OSpawner (configured for Stage 1)
   - Instance `TrashZone.tscn` (bottom-right)
   - Add Node: ReactionHandler (configured for PHOTOSYNTHESIS)
   - Instance `ReactionEffect.tscn` (green color)
   - Add Node: OutputSpawner

5. Add Camera2D:
   - Position: (640, 360)
   - Enabled: true

6. Add CameraShake node

7. Save scene

**Human Checkpoint**:
- [ ] Scene opens without errors
- [ ] Visual layout: light blue sky, brown soil bottom
- [ ] Sun rays visible from top-left
- [ ] Chloroplast workspace at center (green circle)
- [ ] Trash zone in bottom-right corner
- [ ] All system nodes present in hierarchy
- [ ] Scene can be run independently (F6)

---

### Task 4.2: Stage 1 Controller Script
**Dependencies**: Task 4.1 (Stage 1 scene assembled)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/stages/Stage1Controller.gd`:
   ```gdscript
   extends Node2D
   class_name Stage1Controller
   
   signal stage_complete()
   
   @export var reaction_handler: ReactionHandler
   @export var reaction_effect: ReactionEffect
   @export var output_spawner: OutputSpawner
   @export var workspace: Workspace
   @export var camera_shake: CameraShake
   
   var glucose_created: int = 0
   var target_glucose: int = GameConstants.STAGE1_GLUCOSE_TARGET
   
   func _ready() -> void:
   	# Initialize GameManager
   	GameManager.start_stage(1)
   	
   	# Connect signals
   	if reaction_handler:
   		reaction_handler.reaction_triggered.connect(_on_reaction_triggered)
   	
   	if reaction_effect:
   		reaction_effect.spawn_outputs.connect(_on_spawn_outputs)
   		reaction_effect.animation_complete.connect(_on_reaction_complete)
   	
   	# Connect GameManager signals for UI updates
   	GameManager.glucose_created_updated.connect(_on_glucose_updated)
   
   func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
   	"""Handle photosynthesis reaction."""
   	# Visual effects
   	if workspace:
   		workspace.pulse_reaction(Color.GREEN)
   	
   	if camera_shake:
   		camera_shake.shake()
   	
   	# Audio
   	AudioManager.play_sound(AudioManager.SoundType.REACTION_PHOTOSYNTHESIS)
   	
   	# Animation
   	if reaction_effect and workspace:
   		reaction_effect.play_reaction(workspace.global_position, input_molecules, output_info)
   
   func _on_spawn_outputs(output_info: Dictionary, center_pos: Vector2) -> void:
   	"""Spawn glucose and O2."""
   	if output_spawner:
   		output_spawner.spawn_photosynthesis_outputs(center_pos)
   
   func _on_reaction_complete() -> void:
   	"""Reaction animation finished."""
   	print("Reaction complete!")
   
   func _on_glucose_updated(count: int) -> void:
   	"""Track glucose creation."""
   	glucose_created = count
   	
   	# Check win condition
   	if glucose_created >= target_glucose:
   		complete_stage()
   
   func complete_stage() -> void:
   	"""Stage 1 complete - advance to Stage 2."""
   	print("Stage 1 Complete!")
   	stage_complete.emit()
   	GameManager.complete_stage(1)
   	
   	# TODO: Show stage complete screen
   
   func restart_stage() -> void:
   	"""Restart Stage 1 from beginning."""
   	# Clear all molecules
   	var molecules = get_tree().get_nodes_in_group("molecules")
   	for molecule in molecules:
   		molecule.queue_free()
   	
   	# Reset workspace
   	if workspace:
   		workspace.clear_molecules()
   	
   	# Reset counters
   	GameManager.start_stage(1)
   	glucose_created = 0
   ```

2. Use tabs, type hints throughout
3. Save script

4. Attach script to Stage 1 scene root and configure exports

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Class name "Stage1Controller" recognized
- [ ] All export variables have references assigned
- [ ] Running Stage 1 scene starts GameManager stage 1
- [ ] Reactions trigger properly
- [ ] Creating 5 glucose prints "Stage 1 Complete!"
- [ ] GameManager.glucose_created increments correctly

---

### Task 4.2: Stage 1 Controller Script
**Dependencies**: Task 4.1 (Stage 1 scene assembled)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/stages/Stage1Controller.gd`:
   ```gdscript
   extends Node2D
   class_name Stage1Controller
   
   signal stage_complete()
   
   @export var reaction_handler: ReactionHandler
   @export var reaction_effect: ReactionEffect
   @export var output_spawner: OutputSpawner
   @export var workspace: Workspace
   @export var camera_shake: CameraShake
   
   var glucose_created: int = 0
   var target_glucose: int = GameConstants.STAGE1_GLUCOSE_TARGET
   
   func _ready() -> void:
   	# Initialize GameManager
   	GameManager.start_stage(1)
   	
   	# Connect signals
   	if reaction_handler:
   		reaction_handler.reaction_triggered.connect(_on_reaction_triggered)
   	
   	if reaction_effect:
   		reaction_effect.spawn_outputs.connect(_on_spawn_outputs)
   		reaction_effect.animation_complete.connect(_on_reaction_complete)
   	
   	# Connect GameManager signals for UI updates
   	GameManager.glucose_created_updated.connect(_on_glucose_updated)
   
   func _on_reaction_triggered(type: ReactionHandler.ReactionType, input_molecules: Array[Molecule], output_info: Dictionary) -> void:
   	"""Handle photosynthesis reaction."""
   	# Visual effects
   	if workspace:
   		workspace.pulse_reaction(Color.GREEN)
   	
   	if camera_shake:
   		camera_shake.shake()
   	
   	# Audio
   	AudioManager.play_sound(AudioManager.SoundType.REACTION_PHOTOSYNTHESIS)
   	
   	# Animation
   	if reaction_effect and workspace:
   		reaction_effect.play_reaction(workspace.global_position, input_molecules, output_info)
   
   func _on_spawn_outputs(output_info: Dictionary, center_pos: Vector2) -> void:
   	"""Spawn glucose and O2."""
   	if output_spawner:
   		output_spawner.spawn_photosynthesis_outputs(center_pos)
   
   func _on_reaction_complete() -> void:
   	"""Reaction animation finished."""
   	print("Reaction complete!")
   
   func _on_glucose_updated(count: int) -> void:
   	"""Track glucose creation."""
   	glucose_created = count
   	
   	# Check win condition
   	if glucose_created >= target_glucose:
   		complete_stage()
   
   func complete_stage() -> void:
   	"""Stage 1 complete - advance to Stage 2."""
   	print("Stage 1 Complete!")
   	stage_complete.emit()
   	GameManager.complete_stage(1)
   	
   	# TODO: Show stage complete screen
   
   func restart_stage() -> void:
   	"""Restart Stage 1 from beginning."""
   	# Clear all molecules
   	var molecules = get_tree().get_nodes_in_group("molecules")
   	for molecule in molecules:
   		molecule.queue_free()
   	
   	# Reset workspace
   	if workspace:
   		workspace.clear_molecules()
   	
   	# Reset counters
   	GameManager.start_stage(1)
   	glucose_created = 0
   ```

2. Use tabs, type hints throughout
3. Save script

4. Attach script to Stage 1 scene root and configure exports

**Human Checkpoint**:
- [ ] Script compiles without errors
- [ ] Class name "Stage1Controller" recognized
- [ ] All export variables have references assigned
- [ ] Running Stage 1 scene starts GameManager stage 1
- [ ] Reactions trigger properly
- [ ] Creating 5 glucose prints "Stage 1 Complete!"
- [ ] GameManager.glucose_created increments correctly

---

### Task 4.3: Stage 1 HUD Implementation
**Dependencies**: Task 4.2 (Stage 1 controller works)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scenes/ui/HUD_Stage1.tscn`:
   - Root: CanvasLayer (name: "HUD")
   - Layer: 10 (appears on top)

2. Add top bar panel:
   - Add child: Panel (name: "TopPanel")
	 - Anchor: Top
	 - Size: 1280×60
	 - Theme: Create new Theme → StyleBox: Dark semi-transparent

3. Add title label:
   - Add child to TopPanel: Label (name: "StageTitle")
	 - Text: "Stage 1: Photosynthesis Factory"
	 - Position: (20, 15)
	 - Font Size: 24
	 - Color: White

4. Add progress label:
   - Add child to TopPanel: Label (name: "ProgressLabel")
	 - Text: "Glucose Created: 0/5"
	 - Position: (900, 15)
	 - Font Size: 20
	 - Color: White

5. Add left panel for molecule counters:
   - Add child: Panel (name: "LeftPanel")
	 - Anchor: Top Left
	 - Size: 200×250
	 - Position: (10, 80)

6. Add molecule counter labels:
   ```
   CO₂: 0
   H₂O: 0
   Photons: 0
   ```
   - Add VBoxContainer to LeftPanel
   - Add Label for each molecule type
   - Font Size: 18

7. Add bottom buttons:
   - Add child: Button (name: "RestartButton")
	 - Text: "Restart Stage"
	 - Position: (20, 660)
	 - Size: (150, 40)
   
   - Add child: Button (name: "HelpButton")
	 - Text: "Help"
	 - Position: (190, 660)
	 - Size: (100, 40)

8. Add workspace full warning:
   - Add child: Label (name: "WarningLabel")
	 - Text: "Workspace Full! Remove molecules to continue"
	 - Position: (400, 400) - center
	 - Font Size: 20
	 - Color: Red
	 - Visible: false (hidden by default)

9. Save scene

**Human Checkpoint**:
- [ ] HUD scene opens without errors
- [ ] All UI elements positioned correctly
- [ ] Title shows "Stage 1: Photosynthesis Factory"
- [ ] Progress shows "Glucose Created: 0/5"
- [ ] Molecule counters visible on left
- [ ] Restart and Help buttons at bottom
- [ ] Warning label hidden by default

---

### Task 4.4: HUD Controller Script
**Dependencies**: Task 4.3 (HUD scene created)  
**Extended thinking**: OFF  
**Reminder**: Before starting, ask the human: "Is extended thinking on? For this task, it should be **OFF**."

**Implementation**:
1. Create `res://scripts/ui/HUD_Stage1.gd`:
   ```gdscript
   extends CanvasLayer
   class_name HUD_Stage1
   
   @onready var progress_label: Label = $TopPanel/ProgressLabel
   @onready var co2_label: Label = $LeftPanel/VBoxContainer/CO2Label
   @onready var h2o_label: Label = $LeftPanel/VBoxContainer/H2OLabel
   @onready var photon_label: Label = $LeftPanel/VBoxContainer/PhotonLabel
   @onready var warning_label: Label = $WarningLabel
   @onready var restart_button: Button = $RestartButton
   @onready var help_button: Button = $HelpButton
   
   signal restart_requested()
   signal help_requested()
   
   func _ready() -> void:
   	# Connect buttons
   	restart_button.pressed.connect(_on_restart_pressed)
   	help_button.pressed.connect(_on_help_pressed)
   	
   	# Connect GameManager signals
   	GameManager.glucose_created_updated.connect(_on_glucose_updated)
   	
   	# Initial update
   	update_progress(0)
   
   func _process(_delta: float) -> void:
   	# Update molecule counters each frame
   	update_molecule_counts()
   
   func update_molecule_counts() -> void:
   	"""Count molecules in scene and update labels."""
   	var co2_count = 0
   	var h2o_count = 0
   	var photon_count = 0
   	
   	# Get workspace reference
   	var workspace = get_node_or_null("/root/Stage1/Workspace")
   	if workspace and workspace is Workspace:
   		for molecule in workspace.molecules_in_workspace:
   			match molecule.molecule_type:
   				Molecule.MoleculeType.CO2:
   					co2_count += 1
   				Molecule.MoleculeType.H2O:
   					h2o_count += 1
   				Molecule.MoleculeType.PHOTON:
   					photon_count += 1
   	
   	# Update labels
   	co2_label.text = "CO₂: %d" % co2_count
   	h2o_label.text = "H₂O: %d" % h2o_count
   	photon_label.text = "Photons: %d" % photon_count
   
   func update_progress(glucose_count: int) -> void:
   	"""Update glucose counter."""
   	progress_label.text = "Glucose Created: %d/%d" % [glucose_count, GameConstants.STAGE1_GLUCOSE_TARGET]
   
   func show_workspace_full_warning(show: bool) -> void:
   	"""Show/hide workspace full warning."""
   	warning_label.visible = show
   
   func _on_glucose_updated(count: int) -> void:
   	update_progress(count)
   
   func _on_restart_pressed() -> void:
   	restart_requested.emit()
   
   func _on_help_pressed() -> void:
   	help_requested.emit()
   ```

2. Use tabs, type hints
3. Save script

4. Attach script to HUD scene root

5. Update Stage1Controller to show workspace warning:
   ```gdscript
   func _ready() -> void:
   	# ... existing code ...
   	
   	if workspace:
   		workspace.capacity_reached.connect(_on_workspace_full)
   		workspace.capacity_available.connect(_on_workspace_available)
   
   func _on_workspace_full() -> void:
   	var hud = get_node_or_null("HUD")
   	if hud and hud.has_method("show_workspace_full_warning"):
   		hud.show_workspace_full_warning(true)
   
   func _on_workspace_available() -> void:
   	var hud = get_node_or_null("HUD")
   	if hud and hud.has_method("show_workspace_full_warning"):
   		hud.show_workspace_full_warning(false)
   ```

**Human Checkpoint**:
- [ ] HUD script compiles without errors
- [ ] Running Stage 1 shows all UI elements
- [ ] Molecule counters update in real-time
- [ ] Progress label updates when glucose created
- [ ] Workspace full warning appears at 20 molecules

**Document prepared by:** Claude (Sonnet 4.5)  
**Date:** November 13, 2025  
**Pipeline Stage:** Stage 5 (Task Generation) - Phase 1  
**Status:** Ready for Claude Code/Haiku execution
