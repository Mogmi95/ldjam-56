extends Node

# Starts at 1
var level_nbr: int = 0
var current_level_sc: Level = null
var x_offset: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Signals.level_ended.connect(_change_level)
    Signals.game_over.connect(game_over)
    Signals.start_game.connect(new_game)
    Signals.mob_died.connect(_on_mob_died)
    $PostFightTimer.timeout.connect(_on_post_fight_timer_timeout)
    new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if $CameraCollision.position.x >= (x_offset + current_level_sc.loading_checkpoint):
        _change_level()

    $Player.set_boundaries(true, current_level_sc.clamp_y, $CameraCollision.position.x)

    if !$PostFightTimer.is_stopped():
        dezoom(delta)
#end

func new_game() -> void:
    current_level_sc = null
    $CameraCollision.position = Vector2.ZERO
    level_nbr = 2
    load_level(level_nbr)
#end

func game_over() -> void:
    $CameraCollision.should_camera_move = false
    $HUD.show_game_over()

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
#end

# Called when level_ended signal is triggered
func _change_level() -> void:
    level_nbr += 1
    load_level(level_nbr)
#end

func _on_mob_died(mob: Mob) -> void:
    if mob.is_boss():
        $PostFightTimer.start()
#end

func _on_post_fight_timer_timeout() -> void:
    print("BITE")
#end

func dezoom(delta: float) -> void:
    var foreground: Sprite2D = current_level_sc.get_node("Foreground")
    var zoom_target = 0.67
    var dezoom_value = delta * (1.0 - zoom_target) / $PostFightTimer.wait_time
    var dezoom_vec = delta * (Vector2(x_offset, -360) - $CameraCollision.global_position) / $PostFightTimer.wait_time

    foreground.scale.x -= dezoom_value
    foreground.scale.y -= dezoom_value
    foreground.global_position -= dezoom_vec

    $MinionManager.scale.x -= dezoom_value
    $MinionManager.scale.y -= dezoom_value

    for minion in $MinionManager.get_children():
        minion.global_position += minion.global_position * dezoom_value
#end
