class_name TasksHUD extends CanvasLayer
@onready var tasks_container: VBoxContainer = %TasksContainer

var tasks: Dictionary[int, bool] = {}
var total_tasks := 0

const TASK_PREFIX := "TASK_HUD_"

func add_task(_name: String) -> int:
	total_tasks += 1
	var label := Label.new()
	label.text = _name
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.name = TASK_PREFIX + str(total_tasks)
	tasks_container.add_child(label)
	tasks[total_tasks] = false
	return total_tasks

func complete_task(task_id: int) -> void:
	tasks[task_id] = true
	var label: Label = tasks_container.get_node(TASK_PREFIX + str(total_tasks))
	if label:
		label.modulate = Color(1.0, 1.0, 1.0, 0.498)
		await get_tree().create_timer(2.0).timeout
		label.queue_free()
	
