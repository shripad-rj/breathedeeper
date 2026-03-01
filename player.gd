extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -850.0
const ACCEL = 3000.0

var current_level = 1

 

const spawnpoints = {
	"level1": [-71, -350],
	"level2": [-71, -350],
	"level3": [-71, -350]
}

const durations = {
	"level1": 30,
	"level2": 80,
	"level3": 75
}

var portal: Node2D

func _ready() -> void:
	var scene_path = get_tree().current_scene.scene_file_path
	var scene_name = scene_path.get_file().get_basename()
	current_level = int(scene_name.trim_prefix("level"))
	$Timer.timeout.connect(restart_level)
	restart_level()

func restart_level() -> void:
	var level_key = "level" + str(current_level)
	print(current_level)
	position.x = spawnpoints[level_key][0]
	position.y = spawnpoints[level_key][1] - 1500
	if current_level == 1: $Timer.wait_time = 30
	elif current_level == 2: $Timer.wait_time = 50
	elif current_level == 3: $Timer.wait_time = 75
	print($Timer.wait_time)
	$Timer.start()

	# Cache portal safely
	portal = get_tree().current_scene.find_child("Portal", true, false)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		$Sprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)

	move_and_slide()

	$Camera2D/ProgressBar.value = 100 * (
		$Timer.time_left / durations["level" + str(current_level)]
	)

	if position.y > 2000:
		restart_level()

	if portal:
		var distance = global_position.distance_to(portal.global_position)
		if distance < 125:
			if current_level < 3:
				current_level += 1
				get_tree().change_scene_to_file(
					"res://level" + str(current_level) + ".tscn"
				)
