extends Node

signal food_consumed(position: Vector2)

signal minion_hurt(minion: Node, source: Node)

signal minions_number_changed(nbr: int)

signal boss_hurt()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
