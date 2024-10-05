extends Node

signal food_spawned(count: int, position: Vector2)

signal food_consumed(position: Vector2)

signal minion_hurt(minion: Node, source: Node)

signal minions_number_changed(nbr: int)

signal mob_hurt()

signal mob_died(mob: Node)

signal level_ended()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    food_spawned.is_null()
    food_consumed.is_null()
    minion_hurt.is_null()
    minions_number_changed.is_null()
    mob_hurt.is_null()
    mob_died.is_null()
