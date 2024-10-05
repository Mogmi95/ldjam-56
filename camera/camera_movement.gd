extends Node2D

# Camera movement speed (pixels)
@export var speed : float = 2.5
@export var should_camera_move: bool

func _process(delta) -> void:
    # TODO: Handle right limits of levels
    if should_camera_move:
        position.x += speed
