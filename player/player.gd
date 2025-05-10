extends CharacterBody2D
class_name Player

enum STATE {
	IDLE,
	RUNNING,
	JUMPING,
}
var state: STATE = STATE.IDLE

@export var terminal_speed: float = 170
@export var jump_velocity: float = -300
@export var acceleration: float = 550

@onready var on_floor_buffer_timer: Timer = $OnFloorBufferTimer
@onready var jump_pressed_buffer_timer: Timer = $JumpPressedBufferTimer

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		set_state(STATE.JUMPING)
		velocity += get_gravity() * delta
	
	else:
		on_floor_buffer_timer.start()
		
		if abs(velocity.x) > 0:
			set_state(STATE.RUNNING)
		else:
			set_state(STATE.IDLE)
	
	if not jump_pressed_buffer_timer.is_stopped() and not on_floor_buffer_timer.is_stopped():
		jump_pressed_buffer_timer.stop()
		on_floor_buffer_timer.stop()
		velocity.y = jump_velocity
	
	var direction: float = Input.get_axis("left", "right")
	x_face_towards(direction)
	
	var drag: float = -1 * acceleration * (velocity.x / terminal_speed)
	if state == STATE.JUMPING:
		drag = sign(drag) * clampf(abs(drag), 0,acceleration)
	
	if direction != 0:
		velocity.x += (direction * acceleration + drag) * delta
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * 2 * delta)
	
	handle_catch_boost()
	
	move_and_slide()


func x_face_towards(new_direction: float) -> void:
	if new_direction == 0:
		return
	if new_direction < 0:
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
	
	facing = Vector2(new_direction,0)

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
func set_state(new_state: STATE) -> void:
	if $BoostAnimationTimer.is_stopped():
		if new_state == STATE.IDLE:
			player_sprite.play("idle")
		elif new_state == STATE.RUNNING:
			player_sprite.play("run")
		elif new_state == STATE.JUMPING:
			player_sprite.play("jump")
	
	state = new_state


var boomerang_scene: PackedScene = preload("res://boomerang/boomerang.tscn")
var can_throw_boomerang: bool = true
var facing: Vector2i = Vector2i.RIGHT
@export var offset: float = 15

func throw_boomerang() -> void:
	var boomerang: Boomerang = boomerang_scene.instantiate()
	boomerang.position = position + (facing * offset)
	boomerang.initalize_velocity(facing)
	SignalBus.add_boomerang_to_level.emit(boomerang)
	can_throw_boomerang = false


@onready var boomerang_thrown_buffer_timer: Timer = $BoomerangThrownBufferTimer
@onready var boomerang_caught_buffer_timer: Timer = $BoomerangCaughtBufferTimer
func caught_boomerang() -> void:
	boomerang_caught_buffer_timer.start()
	handle_catch_boost()

@export var catch_boost_speed: float = 300
func handle_catch_boost() -> void:
	if not boomerang_caught_buffer_timer.is_stopped() and not boomerang_thrown_buffer_timer.is_stopped():
		var direction: Vector2 = Input.get_vector("left","right","jump","down")
		velocity = catch_boost_speed * direction
		boomerang_caught_buffer_timer.stop()
		boomerang_thrown_buffer_timer.stop()
		boomerang_caught_buffer_timer.timeout.emit()
		$BoostAnimationTimer.start()
		player_sprite.play("boost")

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("jump"):
		jump_pressed_buffer_timer.start()
	
	elif event.is_action_released("jump") and velocity.y < 0:
		velocity.y /= 2
	
	elif event.is_action_pressed("throw"):
		if can_throw_boomerang:
			throw_boomerang()
		boomerang_thrown_buffer_timer.start()


func _on_boomerang_caught_buffer_timer_timeout() -> void:
	can_throw_boomerang = true
