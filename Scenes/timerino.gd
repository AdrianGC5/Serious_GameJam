extends Node2D

@onready var labe = %time
@onready var tim = %Timer
@onready var total_time_secs: int = 0



func _on_timer_timeout() -> void:
	print(total_time_secs)
	total_time_secs += 1
