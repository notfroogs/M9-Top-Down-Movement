extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deacceleration := 1080
@onready var _dust: GPUParticles2D = %Dust
@onready var _runner_visual: RunnerVisual = %RunnerVisualPurple



func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(get_global_mouse_position())
	var distance := global_position.distance_to(get_global_mouse_position())
	var speed := max_speed if distance > 100 else max_speed * distance / 100
	var desired_velocity = direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
	var _direction_discrete := direction.sign()
	if velocity.length() > 10.0:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), 8.0 * delta)
		var current_speed_percent = velocity.length()/max_speed
		_runner_visual.animation_name=(
			RunnerVisual.Animations.RUN
			if current_speed_percent > 0.8
			else RunnerVisual.Animations.WALK
		)
		_dust.emitting = true
	else:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
