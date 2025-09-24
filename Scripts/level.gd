extends Node2D


@onready var player: Player = $Player
@onready var timer: Label = $CanvasLayer/Timer

var time: float = 0.0
var is_timer_running: bool = true

func _ready() -> void:
	player.level_finished.connect(level_finished)


func _process(delta: float) -> void:
	if is_timer_running:	
		time += delta
		timer.text = "%.1f" % time
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene.call_deferred()
	

func level_finished() -> void:
	is_timer_running = false
	player.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
