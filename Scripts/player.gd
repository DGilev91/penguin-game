extends CharacterBody2D

@export_category("Gravity")
@export var up_gravity: float = 250.0
@export var down_gravity: float = 500.0

@export_category("Jump")
@export var jump_forse: float = 180.0
@export var unjump_forse: float = 25.0

func _physics_process(delta: float) -> void:
	velocity.x += 500.0 * delta
	velocity.x = min(velocity.x, 100.0)
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_forse
	else:
		if Input.is_action_just_released("ui_up"):
			velocity.y = unjump_forse
			
		if velocity.y > 0:
			velocity.y += down_gravity * delta
		else:
			velocity.y += up_gravity * delta
	
	move_and_slide()
