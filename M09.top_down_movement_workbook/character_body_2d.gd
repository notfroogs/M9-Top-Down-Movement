extends CharacterBody2D

@onready var _runner_visual: RunnerVisual = %RunnerVisualRed

@export var max_speed= 600.0
@export var acceleration := 1200.0
@export var deacceleration := 1080.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity = direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deacceleration * delta)
	move_and_slide()
	var direction_discrete := direction.sign()
	if direction.length() > 0.0:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		var current_speed_percent = velocity.length()/max_speed
		_runner_visual.animation_name=(
			RunnerVisual.Animations.WALK
			if current_speed_percent > 0.8
			else RunnerVisual.Animations.RUN
		)
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
