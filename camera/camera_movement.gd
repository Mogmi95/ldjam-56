extends Node2D

# Camera movement speed (pixels)
@export var speed : float = 2.5
var should_camera_move: bool
var where_to_max : int = 0

func _process(delta) -> void:
    delta = delta
    if should_camera_move:
        position.x += speed


func set_movement_and_back_collision(should_move: bool, where_to: int) -> void:
    should_camera_move = should_move
    where_to_max = where_to
    $Area2D/CollisionShape2D.set_deferred("disabled", not should_move)
