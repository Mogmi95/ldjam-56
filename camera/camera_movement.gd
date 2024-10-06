extends Node2D

# Camera movement speed (pixels)
@export var speed: float = 2.5

var where_to: int

func _process(delta) -> void:
    if position.x < where_to:
        position.x += speed


func set_destination_and_back_collision(should_kill: bool, destination: int) -> void:
    where_to = destination
    $Area2D/CollisionShape2D.set_deferred("disabled", not should_kill)
