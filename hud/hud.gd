extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.minions_number_changed.connect(update_minions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func update_minions(minions_nbr: int) -> void:
    $Minions.text = str(minions_nbr)
