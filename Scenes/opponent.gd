extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

var random := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Taskmanager.enemy_spin.connect(enemy_spin)

func enemy_spin() -> void:
	label.text = Taskmanager.wheel_result
	await Taskmanager.pirate
	await get_tree().create_timer(2).timeout
	animation_player.play("Show")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
