extends CharacterBody2D
class_name Player


@export var terminal_speed: float = 170
@export var jump_velocity: float = -300
@export var acceleration: float = 750

@onready var on_floor_buffer_timer: Timer = $Timers/OnFloorBufferTimer
@onready var jump_pressed_buffer_timer: Timer = $Timers/JumpPressedBufferTimer

@onready var gravity_disabled_timer: Timer = $Timers/GravityDisabledTimer # used during dashes

@export var stall_velociy: float = -200

enum ANIMATION_STATE {
	IDLE,
	RUNNING,
	JUMPING,
}
var state: ANIMATION_STATE = ANIMATION_STATE.IDLE
@onready var pause_animation_changes_timer: Timer = $Timers/PauseAnimationChangesTimer


func _ready() -> void:
	SignalBus.death.connect(on_death)


func on_death() -> void:
	player_sprite.play("death")
	death.play(0)
	run.stop()
	jump_audio.stop()
	boost.stop()
	pause_animation_changes_timer.start(.2)
	velocity = Vector2.ZERO
	process_mode = Node.PROCESS_MODE_DISABLED # may be a better way of doing this

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		
		handle_catch_boost() # move this somewhere else later for further implementation #not moving it somewhere else

		set_state(ANIMATION_STATE.JUMPING)
		handle_gravity(delta)
	
	
	else: # on floor
		on_floor_buffer_timer.start()
		
		can_throw_boomerang = true
		
		if abs(velocity.x) > 0:
			set_state(ANIMATION_STATE.RUNNING)
		else:
			set_state(ANIMATION_STATE.IDLE)
	
	if not jump_pressed_buffer_timer.is_stopped() and not on_floor_buffer_timer.is_stopped():
		jump()
	
	var direction: float = Input.get_axis("left", "right")
	x_face_towards(direction)
	
	var drag: float = -1 * acceleration * (velocity.x / terminal_speed)
	
	if state == ANIMATION_STATE.JUMPING:
		drag = sign(drag) * clampf(abs(drag), 0,acceleration)
	
	
	if direction != 0:
		var net_acceleration: float = (direction * acceleration + drag) * delta
		
		if direction != sign(velocity.x): # If decelerating
			velocity.x += net_acceleration * 2
		else: # If accelerating
			velocity.x += net_acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * 2 * delta)
	
	
	move_and_slide()


func handle_gravity(delta: float) -> void:
	if gravity_disabled_timer.is_stopped():
		velocity += get_gravity() * delta


func jump() -> void:
	
	jump_pressed_buffer_timer.stop()
	on_floor_buffer_timer.stop()
	if not boomerang_caught_buffer_timer.is_stopped():
		velocity.y = jump_velocity - (catch_boost_speed / 4)
		boost.play(0)
		boomerang_caught_buffer_timer.stop()
		pause_animation_changes_timer.stop()
	else:
		velocity.y = jump_velocity
		jump_audio.play(0)


func x_face_towards(new_direction: float) -> void:
	if new_direction == 0:
		return
	if new_direction < 0:
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
	
	facing = Vector2(new_direction,0)


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var jump_audio: AudioStreamPlayer2D = $Jump
@onready var boost: AudioStreamPlayer2D = $Boost
@onready var death: AudioStreamPlayer2D = $Death
@onready var run: AudioStreamPlayer2D = $Run
@onready var catch: AudioStreamPlayer2D = $Catch
func set_state(new_state: ANIMATION_STATE) -> void:
	if pause_animation_changes_timer.is_stopped():
		if new_state == ANIMATION_STATE.IDLE:
			player_sprite.play("idle")
			run.stop()
			jump_audio.stop()
		
		elif new_state == ANIMATION_STATE.RUNNING:
			player_sprite.play("run")
			jump_audio.stop()
			if not run.playing:
				run.play(0)
				
		
		elif new_state == ANIMATION_STATE.JUMPING:
			player_sprite.play("jump")
			run.stop()
	
	state = new_state


var boomerang_scene: PackedScene = preload("res://boomerang/boomerang.tscn")
var has_boomerang: bool = true
var facing: Vector2i = Vector2i.RIGHT
@export var offset: float = 15

func throw_boomerang() -> void:
	var boomerang: Boomerang = boomerang_scene.instantiate()
	var speed: float = abs(velocity.x)
	
	boomerang.position = position + (facing * offset)
	boomerang.initalize_velocity(facing,speed)
	
	SignalBus.add_boomerang_to_level.emit(boomerang)
	
	has_boomerang = false
	can_throw_boomerang = false
	
	if not is_on_floor() and velocity.y > 0:
		stall()

func stall() -> void:
	pass
	#velocity.y = stall_velociy

func caught_boomerang() -> void: # called by boomerang
	
	catch.play(0)
	player_sprite.play("catch")
	pause_animation_changes_timer.start(.5)
	boomerang_caught_buffer_timer.start()
	has_boomerang = true


@onready var boomerang_caught_buffer_timer: Timer = $Timers/BoomerangCaughtBufferTimer
@export var catch_boost_speed: float = 300
@export var catch_boost_time: float = .1
func handle_catch_boost() -> void:
	if not boomerang_caught_buffer_timer.is_stopped() and not jump_pressed_buffer_timer.is_stopped():
		boomerang_caught_buffer_timer.stop()
		jump_pressed_buffer_timer.stop()
		
		boost.play(0)
		run.stop()
		jump_audio.stop()
		pause_animation_changes_timer.stop()
		
		var direction: Vector2 = Input.get_vector("left","right","up","down")
		if direction == Vector2.ZERO:
			direction = facing
		
		pause_animation_changes_timer.start(catch_boost_time)
		player_sprite.play("boost")
		
		velocity = catch_boost_speed * direction
		gravity_disabled_timer.start(catch_boost_time)

var can_throw_boomerang: bool = true
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("jump"):
		jump_pressed_buffer_timer.start()
	
	elif event.is_action_released("jump") and velocity.y < 0:
		velocity.y /= 2
	
	elif event.is_action_pressed("throw"):
		if has_boomerang:
			if can_throw_boomerang:
				throw_boomerang()
