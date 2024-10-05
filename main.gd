extends Node

# Starts at 1
var level_nbr : int = 1
var current_level_sc: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func new_game() -> void:
    level_nbr = 1
    load_level(level_nbr)

func load_level(lvl_nbr: int) -> void:
    if current_level_sc:
        remove_child(current_level_sc)
    current_level_sc = load("res://levels/level_%s.tscn" % lvl_nbr).instantiate()
    $CameraCollision.should_camera_move = current_level_sc.should_camera_move
    add_child(current_level_sc)
