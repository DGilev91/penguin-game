extends CharacterBody2D

@export_category("Gravity")
@export var up_gravity: float = 250.0
@export var down_gravity: float = 500.0

@export_category("Jump")
@export var jump_forse: float = 180.0
@export var unjump_forse: float = 25.0

@export_category("Speed")
@export var max_speed: float = 290
@export var acceleration: float = 150

@export_category("Froction")
@export var friction: float = 200
@export var air_friction: float = 60


func _physics_process(delta: float) -> void:
	if is_on_floor():
		if velocity.x <= max_speed:
			velocity.x = move_toward(velocity.x, max_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, max_speed, friction * delta)
			
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_forse
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)
		
		if Input.is_action_just_released("ui_up"):
			velocity.y = unjump_forse
			
		if velocity.y > 0:
			velocity.y += down_gravity * delta
		else:
			velocity.y += up_gravity * delta
	
	move_and_slide()
