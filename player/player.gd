extends Node2D

@export var speed = 450
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    screen_size = get_viewport_rect().size

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
    #position = position.clamp(Vector2.ZERO, screen_size)
