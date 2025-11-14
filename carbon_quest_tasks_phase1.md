# Carbon Quest: From Sunlight to Life - Claude Code Task List
## Phase 1: Foundation & Architecture
### For Claude Haiku 4.5 Execution

**Project**: Carbon Quest: From Sunlight to Life  
**Engine**: Godot 4.5  
**Language**: GDScript (tabs for indentation, NOT spaces)  
**Platform**: HTML5 (Web - Chromebook deployment)  
**GDD Version**: 1.1  
**Implementation Plan Version**: 1.1

**CRITICAL: All tasks defer to Implementation Plan and GDD documentation for specifications.**

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

**Document prepared by:** Claude (Sonnet 4.5)  
**Date:** November 13, 2025  
**Pipeline Stage:** Stage 5 (Task Generation) - Phase 1  
**Status:** Ready for Claude Code/Haiku execution
