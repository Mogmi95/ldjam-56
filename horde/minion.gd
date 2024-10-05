extends CharacterBody2D

const SPEED = 300.0
var target: Node2D
var last_position: Vector2
var last_traveled_distances = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    last_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var distance_moved_since_last_position = global_position.distance_to(last_position)
    last_position = global_position
    var has_minion_significantly_moved = is_minion_significantly_moving(distance_moved_since_last_position)

    if has_minion_significantly_moved:
        $AnimatedSprite2D.animation = "walk"
        $AnimatedSprite2D.flip_h = velocity.x < 0
    else:
        $AnimatedSprite2D.animation = "idle"

func _physics_process(delta):
    var distance_to_target = global_position.distance_to(target.global_position)
    if distance_to_target > 5:
        velocity = global_position.direction_to(target.global_position)
        velocity *= SPEED * delta
        var collision = move_and_collide(velocity)
    else:
        velocity = Vector2.ZERO

func is_minion_significantly_moving(distance_moved_since_last_position):
    last_traveled_distances.append(distance_moved_since_last_position)
    var sum = 0
    for distance in last_traveled_distances:
        sum += distance
    if last_traveled_distances.size() > 5:
        last_traveled_distances.pop_front()
    return (sum / last_traveled_distances.size()) > 1

func set_target(target: Node2D):
    self.target = target
