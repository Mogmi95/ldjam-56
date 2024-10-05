extends Node2D

@export var target: Node2D
@export var minion_numbers = 20
var minion_scene = preload("res://horde/Minion.tscn")

var minions = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for i in range(0, minion_numbers):
        var minion = minion_scene.instantiate()
        minion.position = generate_new_minion_position()
        minion.set_target(target)
        minions.append(minion)
        add_child((minion))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

# Find an empty space to spawn a new minion
func generate_new_minion_position():
    var new_position = target.global_position
    if minions.size() > 0:
        var last_minion = minions[-1]
        new_position = last_minion.position + Vector2(0.01, 0.01)
    return new_position
