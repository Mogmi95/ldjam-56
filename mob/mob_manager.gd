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

func spawn_food(position: Vector2):
    pass

func _on_food_consumed(food: Node):
    food.queue_free()

func _on_mob_died(mob: Node):
    mob.hide()
    mob.queue_free()
    spawn_food(mob.position)
