extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for minion in $Minions.get_children():
        minion.force_walk()
        minion.force_mute()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_exit_button_pressed() -> void:
    get_tree().quit()


func _on_start_button_pressed() -> void:
    Signals.start_game.emit()
