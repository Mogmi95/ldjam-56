extends CanvasLayer


var dialog = null
var avatar_bird = load("res://assets/dialogs/bird.png")
var avatar_minion = load("res://assets/dialogs/raptor.png")
var avatar_cathy = load("res://assets/dialogs/girl.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.minions_number_changed.connect(update_minions)
    Signals.start_display_dialog.connect(show_dialog)
    $BlaBlaContainer/ColorRect/ColorRect/Avatar.texture = avatar_bird

func _input(event) -> void:
    if dialog != null:
        if Input.is_action_pressed("player_dash"):
            show_next_dialog()


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
    $RetryButton.show()
    $QuitButton.show()

func update_dash(value: int) -> void:
    $TextureProgressBar.value = value

# Display a dialog then close the HUD
# format of dialog is as follow:
# [["bird","Hello world!"],["minion", "Roar?"]]
func show_dialog(new_dialog):
    if new_dialog == null:
        return
    get_tree().paused = true
    dialog = new_dialog
    $BlaBlaContainer.show()
    show_next_dialog()

func show_next_dialog():
    if dialog.size() == 0:
        dialog = null
        $BlaBlaContainer.hide()
        Signals.stop_display_dialog.emit()
        get_tree().paused = false
        return
    var next_message = dialog.pop_front()
    match (next_message[0]):
        "bird":
            $BlaBlaContainer/ColorRect/ColorRect/Avatar.texture = avatar_bird
        "minion":
            $BlaBlaContainer/ColorRect/ColorRect/Avatar.texture = avatar_minion
        "cathy":
            $BlaBlaContainer/ColorRect/ColorRect/Avatar.texture = avatar_cathy
    $BlaBlaContainer/BlaBlaText.text = next_message[1]

func _on_quit_button_pressed() -> void:
    get_tree().quit()


func _on_retry_button_pressed() -> void:
    $RetryButton.hide()
    $QuitButton.hide()
    $Message.hide()
    Signals.restart_game.emit()
