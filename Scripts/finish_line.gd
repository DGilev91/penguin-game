extends TextureRect

@export var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player is Player, "You forgot to set the player on your finish line")
	player.finish_x = global_position.x
