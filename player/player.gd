extends CharacterBody2D
class_name Player


@export var terminal_speed: float = 170
@export var jump_velocity: float = -300
@export var acceleration: float = 510

@onready var on_floor_buffer_timer: Timer = $OnFloorBufferTimer
@onready var jump_pressed_buffer_timer: Timer = $JumpPressedBufferTimer

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
		velocity.x += (direction * acceleration + drag) * delta
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * 2 * delta)
	
	move_and_slide()


var boomerang_scene: PackedScene = preload("res://boomerang/boomerang.tscn")
var can_throw_boomerang: bool = true
var facing: Vector2i = Vector2i.RIGHT
@export var offset: float = 15

func throw_boomerang() -> void:
	var boomerang: Boomerang = boomerang_scene.instantiate()
	boomerang.position = position + (facing * offset)
	boomerang.initalize_velocity(facing)
	SignalBus.add_boomerang_to_level.emit(boomerang)


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("jump"):
		jump_pressed_buffer_timer.start()
	
	elif event.is_action_released("jump") and velocity.y < 0:
		velocity.y /= 2
	
	elif event.is_action_pressed("throw") and can_throw_boomerang:
		throw_boomerang()
