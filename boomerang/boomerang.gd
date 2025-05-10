extends CharacterBody2D
class_name Boomerang

enum STATE {
	OUT = 0,
	BACK = 1,
}
var state: STATE = STATE.OUT

@export var inital_speed_out: float = 200
@export var deceleration_out: float = 120
@export var inital_speed_back: float = 150
@export var acceleration_back: float = 1000
@export var terminal_return_speed: float = 600

@onready var player: Player = get_tree().get_first_node_in_group("player")


func initalize_velocity(direction: Vector2i) -> void:
	velocity = direction * inital_speed_out


func _process(_delta: float) -> void:
	if velocity.x == 0 and not Input.is_action_pressed("throw"):
		state = STATE.BACK
		$Area2D.monitoring = true
		$CollisionShape2D.disabled = true
		var direction: Vector2 = position.direction_to(player.position)
		velocity = direction * inital_speed_back

func _physics_process(delta: float) -> void:
	
	if state == STATE.OUT:
		velocity.x = move_toward(velocity.x,0,deceleration_out * delta)
	
	elif state == STATE.BACK:
		var direction: Vector2 = position.direction_to(player.position)
		var drag: Vector2 = (velocity/terminal_return_speed) * acceleration_back * delta
		velocity += (acceleration_back * direction * delta) - drag
	
	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision != null:
		velocity = Vector2.ZERO


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		queue_free()
	else:
		pass
