extends Node2D

@export var speed = 450
var screen_size
var level_boundaries: Vector2i
var clamp_x: bool
var last_x: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    screen_size = get_viewport_rect().size
    level_boundaries = Vector2i(0, screen_size.y)
    last_x = 0
    clamp_x = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var velocity = Vector2.ZERO
    if Input.is_action_pressed("player_right"):
        velocity.x += 1
    if Input.is_action_pressed("player_left"):
        velocity.x -= 1
    if Input.is_action_pressed("player_down"):
        velocity.y += 1
    if Input.is_action_pressed("player_up"):
        velocity.y -= 1

    if velocity.length() > 0:
        velocity = velocity.normalized() * speed

    position += velocity * delta
    position.y = clampi(position.y, level_boundaries.x, level_boundaries.y)
    if clamp_x:
        position.x = clampi(position.x, last_x, last_x + screen_size.x)


func set_boundaries(xclamp: bool, y_boundaries: Vector2i, xlast: int) -> void:
    level_boundaries = y_boundaries
    clamp_x = xclamp
    last_x = xlast
