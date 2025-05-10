extends CharacterBody2D
class_name Player

@export var terminal_speed: float = 170
@export var jump_velocity: float = -300
@export var acceleration: float = 30

@onready var on_floor_buffer_timer: Timer = $OnFloorBufferTimer
@onready var jump_pressed_buffer_timer: Timer = $JumpPressedBufferTimer

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("jump"):
		jump_pressed_buffer_timer.start()
	
	if event.is_action_released("jump") and velocity.y < 0:
		velocity.y /= 2

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		on_floor_buffer_timer.start()
	
	if not jump_pressed_buffer_timer.is_stopped() and not on_floor_buffer_timer.is_stopped():
		jump_pressed_buffer_timer.stop()
		on_floor_buffer_timer.stop()
		velocity.y = jump_velocity
	
	var direction: float = Input.get_axis("left", "right")
	var drag: float = -1 * acceleration * (velocity.x / terminal_speed)
	if direction != 0:
		velocity.x += direction * acceleration + drag
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	
	move_and_slide()
