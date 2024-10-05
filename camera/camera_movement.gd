extends Node2D

# Camera movement speed (pixels)
@export var speed : float = 2.5

func _process(delta) -> void:
    # TODO: Handle right limits of levels
    position.x += speed
