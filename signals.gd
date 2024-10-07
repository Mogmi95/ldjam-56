extends Node

signal food_spawned(count: int, position: Vector2)

signal food_consumed(food: Node)

signal minion_hurt(minion: Node, source: Node)

signal minion_dead(minion: Node)

signal minions_number_changed(nbr: int)

signal mob_hurt(mob: Mob)

signal mob_died(mob: Mob)

signal level_ended()

signal start_display_dialog(dialog)

signal stop_display_dialog(dialog)

signal game_over()

signal start_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    food_spawned.is_null()
    food_consumed.is_null()
    minion_hurt.is_null()
    minions_number_changed.is_null()
    mob_hurt.is_null()
    mob_died.is_null()
    level_ended.is_null()
    game_over.is_null()
    start_game.is_null()
