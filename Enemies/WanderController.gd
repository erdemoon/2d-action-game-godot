extends Node2D

export(int) var _range = 32

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-_range,_range),rand_range(-_range,_range))
	target_position = start_position + target_vector

func time_left():
	return timer.time_left
	
func start_wander_timer(duration):
	timer.start(duration)
	
func _on_Timer_timeout():
	update_target_position()
