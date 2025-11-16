extends CanvasLayer
class_name StageComplete

@onready var continue_button: Button = $Content/ContinueButton
@onready var stage_label: Label = $Content/StageLabel
@onready var time_label: Label = $Content/StatisticsPanel/VBoxContainer/TimeLabel
@onready var reactions_label: Label = $Content/StatisticsPanel/VBoxContainer/ReactionsLabel
@onready var efficiency_label: Label = $Content/StatisticsPanel/VBoxContainer/EfficiencyLabel

signal continue_pressed()


func _ready() -> void:
	visible = false
	continue_button.pressed.connect(_on_continue_pressed)


func show_completion(stage_num: int, time: float, reactions: int, efficiency: float) -> void:
	"""Display stage completion with statistics."""
	visible = true

	# Update labels
	stage_label.text = "Stage %d Complete!" % stage_num
	time_label.text = "Time: %.1f seconds" % time
	reactions_label.text = "Reactions: %d" % reactions
	efficiency_label.text = "Efficiency: %.1f%%" % (efficiency * 100.0)

	# Play fanfare sound
	AudioManager.play_sound(AudioManager.SoundType.STAGE_COMPLETE)


func _on_continue_pressed() -> void:
	continue_pressed.emit()
	visible = false
