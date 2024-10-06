extends Node

# Starts at 1
var level_nbr: int = 0
var current_level_sc: Level = null
var x_offset: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Signals.level_ended.connect(_change_level)
    new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if $CameraCollision.position.x >= (x_offset + current_level_sc.loading_checkpoint):
        _change_level()
    $Player.set_boundaries(true, # clamp x
                           current_level_sc.clamp_y,
                           $CameraCollision.position.x
    )

func new_game() -> void:
    level_nbr = 0
    load_level(level_nbr)

# Transitions between levels should be handled here
func load_level(lvl_nbr: int) -> void:
    print("Loading level %d" % level_nbr)

    if current_level_sc:
        x_offset += current_level_sc.level_width

    current_level_sc = load("res://levels/level_%s.tscn" % lvl_nbr).instantiate()

    $CameraCollision.set_destination_and_back_collision(current_level_sc.should_camera_move,
                                                        x_offset + current_level_sc.camera_where_to)
    $MinionManager.set_minimum_number_of_minions(current_level_sc.minimum_number_of_minions)

    current_level_sc.global_position.x = x_offset

    print("Adding level at x: %d" % current_level_sc.global_position.x)
    print("Camera x position: %d" % $CameraCollision.position.x)

    call_deferred("add_child", current_level_sc)

# Called when level_ended signal is triggered
func _change_level() -> void:
    level_nbr += 1
    load_level(level_nbr)
