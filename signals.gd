extends Node

signal food_spawned(count: int, position: Vector2)

signal food_consumed(food: Node)

signal minion_hurt(minion: Node, source: Node)

signal minions_number_changed(nbr: int)

signal mob_hurt(mob: Node)

signal mob_died(mob: Node, was_boss: bool)

signal level_ended()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    food_spawned.is_null()
    food_consumed.is_null()
    minion_hurt.is_null()
    minions_number_changed.is_null()
    mob_hurt.is_null()
    mob_died.is_null()
