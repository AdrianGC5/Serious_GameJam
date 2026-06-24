extends Node

signal start
signal spin
signal death
signal end
signal pirate
signal table
signal enemy_spin
signal spin_finished

var game_has_booted: bool
var game_has_started: bool

var wheel_result: String

var player_turn: bool

var is_interacting: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
