extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -850.0
const ACCEL = 3000.0
var current_level = 1
const spawnpoints = {
	"level1" = [-71, -350],
	"level2" = [-71, -350]
}

const durations = {
	"level1" = 30,
	"level2" = 30
}
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		if direction < 0: $Sprite2D.flip_h = 1
		elif direction > 0: $Sprite2D.flip_h = 0
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)

	move_and_slide()
	
	if position.y > 2000:
		position.x = spawnpoints["level" + str(current_level)][0]
		position.y = spawnpoints["level" + str(current_level)][1] - 1500
