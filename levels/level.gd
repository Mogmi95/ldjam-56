extends Node2D

class_name Level

@export var should_camera_move: bool
@export var minimum_number_of_minions: int
# y Min, y Max
@export var clamp_y: Vector2i
@export var level_width: int
@export var camera_where_to: int
@export var loading_checkpoint: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    delta = delta
    pass

# Triggered when ending_x has been reached
func _on_body_entered(body: Node2D) -> void:

    $Area2D/CollisionShape2D.set_deferred("disabled", true)


func _on_timer_timeout() -> void:
    Signals.level_ended.emit()
