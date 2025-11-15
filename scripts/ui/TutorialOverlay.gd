extends CanvasLayer
class_name TutorialOverlay

signal tutorial_complete()

@onready var instruction_label: Label = $Content/InstructionLabel
@onready var got_it_button: Button = $Content/GotItButton

var current_step: int = 0
var tutorial_steps: Array[Dictionary] = []
var auto_dismiss_timer: Timer


func _ready() -> void:
	got_it_button.pressed.connect(_on_got_it_pressed)
	auto_dismiss_timer = Timer.new()
	add_child(auto_dismiss_timer)
	auto_dismiss_timer.timeout.connect(_on_auto_dismiss)
	auto_dismiss_timer.one_shot = true
	auto_dismiss_timer.wait_time = 30.0
	visible = false


func show_tutorial(steps: Array[Dictionary]) -> void:
	tutorial_steps = steps
	current_step = 0
	visible = true
	show_step(current_step)
	auto_dismiss_timer.start()


func show_step(step_index: int) -> void:
	if step_index >= tutorial_steps.size():
		complete_tutorial()
		return

	var step = tutorial_steps[step_index]
	instruction_label.text = step.get("text", "")


func _on_got_it_pressed() -> void:
	current_step += 1
	if current_step < tutorial_steps.size():
		show_step(current_step)
	else:
		complete_tutorial()


func _on_auto_dismiss() -> void:
	complete_tutorial()


func complete_tutorial() -> void:
	visible = false
	auto_dismiss_timer.stop()
	tutorial_complete.emit()
