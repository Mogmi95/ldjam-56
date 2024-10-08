extends Node2D

@export var leader: Node2D
@export var target: Node2D

var minimum_number_of_minions
var minion_scene = preload("res://minion/Minion.tscn")

var minions = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.minion_dead.connect(_on_minion_dead)
    Signals.food_consumed.connect(_on_food_consumed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func set_minimum_number_of_minions(min_number_of_minions: int):
    minimum_number_of_minions = min_number_of_minions
    _spawn_minimum_number_of_minions()

func _spawn_minimum_number_of_minions():
    if minions.size() < minimum_number_of_minions:
        var pos = leader.global_position
        for i in range(minions.size(), minimum_number_of_minions):
            pos = _generate_spiral_coordinate_given_iteration(pos, i)
            _spawn(pos)

# Find an empty space to spawn a new minion
func generate_new_minion_position():
    var new_position = leader.global_position
    if minions.size() > 0:
        var last_minion = minions[-1]
        new_position = last_minion.position + Vector2(0.01, 0.01)
    return new_position

func _spawn(pos: Vector2):
    var minion = minion_scene.instantiate()
    minion.set_leader(leader)
    minion.set_target(target)
    minions.append(minion)
    add_child(minion)
    minion.global_position = pos
    minion.name = "Minion"
    _emit_number_change()
    return minion

func _on_minion_dead(minion: Node):
    minions.erase(minion)
    minion.queue_free()
    _emit_number_change()
    if minions.size() == 0:
        Signals.game_over.emit()

func _on_food_consumed(food: Node):
    var pos = food.global_position
    $Nom.play()
    for i in range(0, food.food_drop):
        pos = _generate_spiral_coordinate_given_iteration(pos, i)
        _spawn(pos)

func _generate_spiral_coordinate_given_iteration(pos: Vector2, iteration: int):
    var unit = 1
    match (iteration % 4):
        0:
            return pos + Vector2(0, unit)
        1:
            return pos + Vector2(unit, 0)
        2:
            return pos - Vector2(0, unit)
        3:
            return pos - Vector2(unit, 0)

func _emit_number_change() -> void:
    Signals.minions_number_changed.emit(minions.size())
