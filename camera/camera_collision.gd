extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    delta = delta
    pass


func _on_body_entered(body: Node2D) -> void:
    if "Minion" in body.name:
        Signals.minion_hurt.emit(body, self)
