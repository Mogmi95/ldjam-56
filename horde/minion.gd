extends CharacterBody2D

const SPEED = 300.0
var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if velocity.x != 0:
        $AnimatedSprite2D.animation = "walk"
        $AnimatedSprite2D.flip_v = false
        # See the note below about the following boolean assignment.
        $AnimatedSprite2D.flip_h = velocity.x < 0
    elif velocity.y < 1:
        $AnimatedSprite2D.animation = "idle"

func _physics_process(delta):
    var distance_to_target = global_position.distance_to(target.global_position)
    if distance_to_target > 5:
        velocity = global_position.direction_to(target.global_position)
        velocity *= SPEED * delta
        move_and_collide(velocity)
    else:
        velocity = Vector2.ZERO

func set_target(target: Node2D):
    self.target = target
