extends Node2D

@export var dialogue: DialogueResource

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Taskmanager.table.connect(table)
	Taskmanager.pirate.connect(pirate)
	Taskmanager.spin.connect(_on_spin)
	
	Taskmanager.player_turn = true
	
	DialogueManager.show_dialogue_balloon(dialogue)
	await DialogueManager.dialogue_ended
	Taskmanager.game_has_booted = true
	animation_player.play("Show")
	await animation_player.animation_finished
	DialogueManager.show_dialogue_balloon(dialogue)

func table():
	animation_player.play("Table")

func pirate():
	animation_player.play("Pirate")

func _process(delta: float) -> void:
	if Taskmanager.game_has_started == true:
		pass


func _on_spin() -> void:
	animation_player.play("ZoomIn")
	await Taskmanager.spin_finished
	animation_player.play("ZoomOut")
	await animation_player.animation_finished
	Taskmanager.pirate.emit()
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(dialogue)
	await DialogueManager.dialogue_ended
	Taskmanager.table.emit()
	await get_tree().create_timer(1.5).timeout
	if !Taskmanager.player_turn:
		Taskmanager.enemy_spin.emit()
