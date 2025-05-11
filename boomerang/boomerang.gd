extends CharacterBody2D
class_name Boomerang

enum STATE {
	OUT,
	BACK,
	TELEPORT,
}
var state: STATE = STATE.OUT

@export var inital_speed_out: float = 180
@export var deceleration_out: float = 200
@export var inital_speed_back: float = 150
@export var acceleration_back: float = 750
@export var terminal_return_speed: float = 450

@export var very_fast_but_not_instant_return_speed: float = 1500

@onready var player: Player = get_tree().get_first_node_in_group("player")


func initalize_velocity(direction: Vector2i) -> void:
	velocity = direction * inital_speed_out


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("return"):
		if state != STATE.BACK:
			set_state(STATE.BACK)
	
	if event.is_action_released("throw"):
		if state == STATE.OUT:
			velocity /= 2


func set_state(new_state: STATE) -> void:
	if new_state == STATE.BACK:
		$Area2D.monitoring = true
		$CollisionShape2D.disabled = true
		var direction: Vector2 = position.direction_to(player.position)
		velocity = direction * inital_speed_back
		$Boomerang.play("boost")
		$LongPressFastReturnTimer.start()
	state = new_state

func _physics_process(delta: float) -> void:
	
	if state == STATE.OUT:
		pass
		velocity.x = move_toward(velocity.x,0,deceleration_out * delta)
	
	elif state == STATE.BACK:
		var direction: Vector2 = position.direction_to(player.position)
		var drag: Vector2 = (velocity/terminal_return_speed) * acceleration_back * delta
		velocity += (acceleration_back * direction * delta) - drag
		
		var angle: float = velocity.angle() + (sign(velocity.x) * (PI/2) - (PI/2))
		rotation = angle
		if not Input.is_action_pressed("return"):
			$LongPressFastReturnTimer.start()
		
	elif state == STATE.TELEPORT:
		position = position.move_toward(player.position,very_fast_but_not_instant_return_speed * delta)
	
	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision != null:
		set_state(STATE.BACK)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.caught_boomerang()
		queue_free()
	else:
		pass


func _on_boomerang_animation_finished() -> void:
	$Boomerang.play("spin")


func _on_long_press_fast_return_timer_timeout() -> void:
	set_state(STATE.TELEPORT)
