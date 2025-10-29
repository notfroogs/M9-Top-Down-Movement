extends Node2D
@onready var _finish_line: FinishLine = %FinishLine
@onready var _runner: Runner = %Runner
@onready var _count_down: CountDown = %CountDown


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_finish_line.body_entered.connect(func(body:Node)-> void:
		if body is not Runner:
			return
		var runner := body as Runner
		runner.set_physics_process(false)
		var destination_position :=(
			_finish_line.global_position +Vector2(0,64)
		)
		runner.walk_to(destination_position)
		runner.walked_to.connect(
			_finish_line.pop_confettis
		)
	)
	_finish_line.confettis_finished.connect(
		get_tree().reload_current_scene.call_deferred
	)
	_count_down.start_counting()
	_runner.set_physics_process(false)
	_count_down.counting_finished.connect(
		func() -> void:
			_runner.set_physics_process(true)
)
