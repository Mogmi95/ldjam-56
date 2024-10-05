extends Node2D

@export var should_camera_move: bool
# y Min, y Max
@export var clamp_y: Vector2i
@export var ending_x: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if should_camera_move and ending_x != 0:
        $Area2D/CollisionShape2D.position.x = ending_x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

# Triggered when ending_x has been reached
func _on_body_entered(body: Node2D) -> void:
    Signals.level_ended.emit()
    $Area2D/CollisionShape2D.set_deferred("disabled", true)
