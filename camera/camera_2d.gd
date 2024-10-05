extends Camera2D

# Camera movement speed (pixels)
@export var speed : float = 2.5

# Camera screen limits from left boundary (pixels)
const CAMERA_RIGHT_LIMIT : int = 1280

func _process(delta) -> void:
    # TODO: Handle right limits of levels
    #if (position.x < CAMERA_RIGHT_LIMIT):
    position.x += speed
