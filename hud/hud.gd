extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.minions_number_changed.connect(update_minions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_minions(minions_nbr: int) -> void:
    $Minions.text = str(minions_nbr)

func show_message(text: String) -> void:
    $Message.text = text
    $Message.show()

func show_game_over() -> void:
    show_message("Game over")
    $StartButton.show()
    $QuitButton.show()

func _on_quit_button_pressed() -> void:
    get_tree().quit()


func _on_start_button_pressed() -> void:
    $StartButton.hide()
    $QuitButton.hide()
    $Message.hide()
    Signals.start_game.emit()
