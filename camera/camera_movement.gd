extends Node2D

# Camera movement speed (pixels)
@export var speed : float = 2.5
var should_camera_move: bool

func _process(delta) -> void:
    # TODO: Handle right limits of levels
    if should_camera_move:
        position.x += speed

func set_movement_and_back_collision(should_move: bool) -> void:
    should_camera_move = should_move
    $Area2D/CollisionShape2D.disabled = not should_move
