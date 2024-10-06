extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.food_consumed.connect(_on_food_consumed)
    Signals.mob_died.connect(_on_mob_died)

var foods = Array()
var boss : Node = null
var mobs = Array()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func spawn_boss():
    pass

func spawn_mob():
    pass

func spawn_food(mob_position: Vector2, quantity_of_food_to_drop):
    var new_food = MobFactory.create_food()
    # TODO Spawn where the boss was
    new_food.position = Vector2(0, 0)
    # TODO Spawn more food
    add_child(new_food)

func _on_food_consumed(food: Node):
    food.hide()
    food.queue_free()

func _on_mob_died(mob: Node):
    mob.hide()
    if mob.food_drop > 0:
        spawn_food(mob.position, mob.food_drop)
    mob.queue_free()
