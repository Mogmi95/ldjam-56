extends Node2D

@export var leader: Node2D
@export var target: Node2D

var minimum_number_of_minions
var minion_scene = preload("res://minion/Minion.tscn")

var minions = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.minion_hurt.connect(_on_minion_hurt)
    Signals.food_consumed.connect(_on_food_consumed)
    # TODO: Find a way to emit minion_number_change

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func set_minimum_number_of_minions(min_number_of_minions: int):
    minimum_number_of_minions = min_number_of_minions
    _spawn_minimum_number_of_minions()

func _spawn_minimum_number_of_minions():
    if minions.size() < minimum_number_of_minions:
        for i in range(minions.size(), minimum_number_of_minions):
            _spawn(generate_new_minion_position())

# Find an empty space to spawn a new minion
func generate_new_minion_position():
    var new_position = leader.global_position
    if minions.size() > 0:
        var last_minion = minions[-1]
        new_position = last_minion.position + Vector2(0.01, 0.01)
    return new_position

func _spawn(position: Vector2):
    var minion = minion_scene.instantiate()
    minion.position = position
    minion.set_leader(leader)
    minion.set_target(target)
    minions.append(minion)
    add_child(minion)
    return minion

func _on_minion_hurt(minion: Node):
    # TODO check that the minion is real, remove it from the list
    minion.die()
    _emit_number_change()

func _on_food_consumed(food: Node):
    _spawn(food.global_position - global_position)

func _emit_number_change() -> void:
    Signals.minions_number_changed.emit(minions.size())
