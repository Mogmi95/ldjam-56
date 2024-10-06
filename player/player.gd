extends Node2D

enum Controller {
    MOUSE,
    KEYBOARD,
}

@export var speed = 450
var screen_size
var level_boundaries: Vector2i
var clamp_x: bool
var last_x: int
var mouse_pos = Vector2.ZERO
var dash_speed: int = 1

var currently_used_controller: Controller = Controller.MOUSE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    screen_size = get_viewport_rect().size
    level_boundaries = Vector2i(0, screen_size.y)
    last_x = 0
    clamp_x = false
    position = Vector2(50, 50)

func _input(event):
    if event is InputEventMouseMotion:
        mouse_pos = event.position
        currently_used_controller = Controller.MOUSE
    else:
        currently_used_controller = Controller.KEYBOARD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var velocity = Vector2.ZERO

    if Input.is_action_pressed("player_dash"):
        # Everything ready to dash
        if $DashTimeout.is_stopped() and $DashTimer.is_stopped():
            $DashTimer.start()
            dash_speed = 2

    if currently_used_controller == Controller.KEYBOARD:
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
    else:
        position.x = last_x + mouse_pos.x
        position.y = mouse_pos.y
    position.y = clamp(position.y, level_boundaries.x, level_boundaries.y)
    if clamp_x:
        position.x = clamp(position.x, last_x, last_x + screen_size.x)


func set_boundaries(xclamp: bool, y_boundaries: Vector2i, xlast: int) -> void:
    level_boundaries = y_boundaries
    clamp_x = xclamp
    last_x = xlast

func get_dash_value() -> int:
    var dashtimer = $DashTimer.time_left / $DashTimer.wait_time * 100
    var dashtimeout = 100 - ($DashTimeout.time_left / $DashTimeout.wait_time * 100)
    if dashtimer > 0:
        return dashtimer
    else:
        return dashtimeout

func _on_dash_timer_timeout() -> void:
    dash_speed = 1
    $DashTimeout.start()
