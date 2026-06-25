extends Node2D

@export var dialogue: DialogueResource

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var upgrade_screen: Control = $UpgradeUILayer/UpgradeScreen
@onready var spin_wheel: Control = $spin_wheel


func _ready() -> void:
	Taskmanager.table.connect(table)
	Taskmanager.pirate.connect(pirate)
	Taskmanager.spin.connect(_on_spin)

	Taskmanager.start_duel()

	DialogueManager.show_dialogue_balloon(dialogue)
	await DialogueManager.dialogue_ended
	Taskmanager.game_has_booted = true
	animation_player.play("Show")
	await animation_player.animation_finished
	DialogueManager.show_dialogue_balloon(dialogue)


func table() -> void:
	animation_player.play("Table")


func pirate() -> void:
	animation_player.play("Pirate")


func _on_spin() -> void:
	animation_player.play("ZoomIn")

	var duel_ended := await _resolve_spin_and_damage()
	if duel_ended:
		return

	animation_player.play("ZoomOut")
	await animation_player.animation_finished
	Taskmanager.pirate.emit()
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(dialogue)
	await DialogueManager.dialogue_ended
	Taskmanager.table.emit()
	await get_tree().create_timer(1.5).timeout
	if not Taskmanager.player_turn:
		Taskmanager.enemy_spin.emit()


func _resolve_spin_and_damage() -> bool:
	while true:
		await Taskmanager.spin_finished
		var action := await Taskmanager.resolve_spin_results()
		if action == "respin":
			spin_wheel.request_spin()
			continue

		Taskmanager.apply_spin_damage()
		break

	if Taskmanager.enemy_health <= 0:
		await _handle_duel_won()
		return true

	if Taskmanager.player_health <= 0:
		await _handle_duel_lost()
		return true

	return false


func _handle_duel_won() -> void:
	await get_tree().create_timer(1.5).timeout
	upgrade_screen.show_upgrade_selection()
	await upgrade_screen.upgrade_picked
	Taskmanager.reset_between_duels()


func _handle_duel_lost() -> void:
	await get_tree().create_timer(1.5).timeout
	Taskmanager.reset_between_duels()
