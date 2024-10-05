extends Node

# Starts at 1
var level_nbr : int = 0
var current_level_sc: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.level_ended.connect(_change_level)
    new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func new_game() -> void:
    level_nbr = 0
    load_level(level_nbr)

# Transitions between levels should be handled here
func load_level(lvl_nbr: int) -> void:
    if current_level_sc:
        call_deferred("remove_child", current_level_sc)
    current_level_sc = load("res://levels/level_%s.tscn" % lvl_nbr).instantiate()
    $CameraCollision.set_movement_and_back_collision(current_level_sc.should_camera_move)
    $Player.set_boundaries(
        not current_level_sc.should_camera_move,
        current_level_sc.clamp_y,
        $CameraCollision.position.x
    )
    $MinionManager.set_minimum_number_of_minions(current_level_sc.minimum_number_of_minions)
    add_child(current_level_sc)

# Called when level_ended signal is triggered
func _change_level() -> void:
    level_nbr += 1
    load_level(level_nbr)
