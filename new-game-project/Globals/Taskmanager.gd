extends Node

signal spin
signal death
signal end

var cams_are_off: bool = false
var crate_check: int
var freeze_player:  bool
var resetted : bool = false
var broken : bool = false
var player_inventory: String

var is_interacting: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
