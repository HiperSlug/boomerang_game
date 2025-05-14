extends CharacterBody2D
class_name Boomerang

enum STATE {
	OUT,
	BACK,
	TELEPORT,
}
var state: STATE = STATE.OUT

@export var inital_speed_out: float = 210
@export var deceleration_out: float = 200
@export var inital_speed_back: float = 150
@export var acceleration_back: float = 600
@export var terminal_return_speed: float = 400

@export var very_fast_but_not_instant_teleport_speed: float = 1000

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var long_press_fast_return_timer: Timer = $LongPressFastReturnTimer


func initalize_velocity(direction: Vector2i, inherited_speed: float) -> void: # called by player
	inherited_speed = 0
	velocity = direction * (inital_speed_out + inherited_speed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		if state == STATE.OUT:
			set_state(STATE.BACK)
	
	elif event.is_action_released("throw"):
		if state == STATE.OUT:
			velocity /= 2


func set_state(new_state: STATE) -> void:
	if new_state == STATE.BACK:
		collision_shape_2d.set_deferred("disabled",true)
		await get_tree().physics_frame
		await get_tree().physics_frame # it seems to take 2 frames for the collision shape to be disabled.
		var direction: Vector2 = position.direction_to(player.position)
		velocity = direction * inital_speed_back
		#$Sprite2D.modulate = Color.RED
		#$Recall.play()
		#var tween: Tween = get_tree().create_tween()
		#tween.tween_property($Sprite2D,"modulate",Color.WHITE,.2)
		#sprite_2d.play("boost")
		long_press_fast_return_timer.start()
	
	state = new_state

@onready var spin: AudioStreamPlayer2D = $Spin
@onready var floating_time_out: Timer = $FloatingTimeOut
@export var pitch_scale_increase: float = .5 / 3
@export var slow_return_pitch_scale: float = .8
func _physics_process(delta: float) -> void:
	
	if player_in_range and state != STATE.OUT:
		player.caught_boomerang()
		queue_free()
	
	if velocity == Vector2.ZERO:
		spin.pitch_scale += pitch_scale_increase * delta
		$Sprite2D.speed_scale += pitch_scale_increase * delta
	else:
		floating_time_out.start()
	
	if state == STATE.OUT:
		velocity.x = move_toward(velocity.x,0,deceleration_out * delta)
	
	elif state == STATE.BACK:
		spin.pitch_scale = slow_return_pitch_scale
		
		var direction: Vector2 = position.direction_to(player.position)
		var drag: Vector2 = (velocity/terminal_return_speed) * acceleration_back * delta
		velocity += (acceleration_back * direction * delta) - drag
		
		var angle: float = velocity.angle() + (sign(velocity.x) * (PI/2) - (PI/2))
		rotation = angle
		
		if not Input.is_action_pressed("throw"):
			long_press_fast_return_timer.start() # May edit this later
		
	elif state == STATE.TELEPORT:
		position = position.move_toward(player.position,very_fast_but_not_instant_teleport_speed * delta)
	
	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision != null:
		set_state(STATE.BACK)


var player_in_range: bool
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true


func _on_boomerang_animation_finished() -> void: # only called after boost ends because "spin" loops
	sprite_2d.play("spin")


func _on_long_press_fast_return_timer_timeout() -> void:
	set_state(STATE.TELEPORT)


func _on_floating_time_out_timeout() -> void:
	set_state(STATE.BACK)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		if state == STATE.OUT:
			
			$WaitTimeBeforeTeleport.start()


func _on_no_collision_starting_timer_timeout() -> void:
	collision_layer = 8


func _on_wait_time_before_teleport_timeout() -> void:
	if not player_in_range:
		set_state(STATE.TELEPORT)
