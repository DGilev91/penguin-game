class_name Player extends CharacterBody2D

@export_category("Gravity")
@export var up_gravity: float = 250.0
@export var down_gravity: float = 500.0

@export_category("Jump")
@export var jump_forse: float = 180.0
@export var unjump_forse: float = 25.0

@export_category("Speed")
@export var max_speed: float = 290
@export var acceleration: float = 150
@export var landing_acceleration: float = 2250.0
@export var air_jump_speed_reduction: float = 1500
@export var coyote_time_amount: float = 0.15

@export_category("Froction")
@export var friction: float = 200
@export var air_friction: float = 60

@onready var anchor: Node2D = $Anchor
@onready var sprite_2d: Sprite2D = $Anchor/Sprite2D


var target_titl: float = 0.0
var air_jump: bool = true
var coyote_time: float = 0.0
var finish_x = -1

func _physics_process(delta: float) -> void:
	coyote_time += delta
		
	check_for_finish_line()
	
	if is_on_floor() or coyote_time <= coyote_time_amount:
		air_jump = true
		target_titl = 0.0
		
		if velocity.x <= max_speed:
			velocity.x = move_toward(velocity.x, max_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, max_speed, friction * delta)
			
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_forse
	else:
		target_titl = clamp(velocity.y / 4,  -30, 30)
		
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)
		
		if Input.is_action_just_pressed("ui_up") and air_jump:
			velocity.y = -jump_forse
			velocity.x -= air_jump_speed_reduction * delta
			air_jump = false
			var tween = create_tween()
			tween.tween_property(sprite_2d, "rotation_degrees", 0, 0.4).from(360 + sprite_2d.rotation_degrees)
			tween.play()
		
		if Input.is_action_just_released("ui_up"):
			velocity.y = unjump_forse
			
		if velocity.y > 0:
			velocity.y += down_gravity * delta
		else:
			velocity.y += up_gravity * delta
	
	var prev_velocity: Vector2 = velocity
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	var just_left_ladge: bool = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ladge:
		coyote_time = 0.0
	
	
	if velocity.y == 0 and prev_velocity.y > 5:
		anchor.scale = Vector2(1.5, 0.8)
		velocity.x += landing_acceleration * delta
		
	sprite_2d.rotation_degrees = lerp(sprite_2d.rotation_degrees, target_titl, 0.2)
	anchor.scale = anchor.scale.lerp(Vector2.ONE, 0.05)



func check_for_finish_line() -> void:
	if global_position.x > finish_x and finish_x != -1:
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
