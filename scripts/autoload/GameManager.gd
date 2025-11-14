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

# Signals
signal stage_completed(stage_num: int)
signal game_completed()
signal glucose_created_updated(count: int)
signal glucose_broken_updated(count: int)
signal balance_time_updated(time: float)


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
