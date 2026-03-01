extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -850.0
const ACCEL = 3000.0
var current_level = 1
const spawnpoints = {
	"level1" = [-71, -350],
	"level2" = [-71, -350],
	"level3" = [-71, -350]
}

const durations = {
	"level1" = 30,
	"level2" = 45,
	"level3" = 45
}

func _ready() -> void:
	$Timer.timeout.connect(restart_level)
	restart_level()


func restart_level() -> void:
	position.x = spawnpoints["level" + str(current_level)][0]
	position.y = spawnpoints["level" + str(current_level)][1] - 1500
	$Timer.wait_time = durations["level" + str(current_level)]
	$Timer.start()
	get_parent().set_scene_file_path("res://level" + str(current_level) + ".tscn") 


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		if direction < 0: $Sprite2D.flip_h = 1
		elif direction > 0: $Sprite2D.flip_h = 0
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)

	move_and_slide()
	$Camera2D/ProgressBar.value = 100*($Timer.time_left / durations["level" + str(current_level)])
	
	if position.y > 2000:
		restart_level()
		
