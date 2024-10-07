extends Node

# Starts at 1
var level_nbr: int = 0
var precedent_level_sc: Level = null
var current_level_sc: Level = null
var x_offset: int = 0
var dezoom_offset: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Signals.level_ended.connect(_change_level)
    Signals.game_over.connect(game_over)
    Signals.start_game.connect(new_game)
    Signals.mob_died.connect(_on_mob_died)
    $PostFightTimer.timeout.connect(_on_post_fight_timer_timeout)
    $Player.hide()
    $HUD.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if current_level_sc != null:
        _update_hud()

        if $CameraCollision.position.x >= (x_offset + current_level_sc.camera_where_to) && precedent_level_sc:
            _unload_level(precedent_level_sc)
            precedent_level_sc = null

            if level_nbr == 6:
                current_level_sc.get_node("Background").show()

        if $CameraCollision.position.x >= (x_offset + current_level_sc.loading_checkpoint):
            _change_level()

        $Player.set_boundaries(true, current_level_sc.clamp_y, $CameraCollision.position.x)

        if !$PostFightTimer.is_stopped():
            dezoom(delta)
#end

func _update_hud() -> void:
    $HUD.update_dash($Player.get_dash_value())

func new_game() -> void:
    $MainMenu.hide()
    $Player.show()
    $HUD.show()
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    current_level_sc = null
    $CameraCollision.position = Vector2.ZERO
    level_nbr = 0
    load_level(level_nbr)
#end

func game_over() -> void:
    $CameraCollision.where_to = 0
    $HUD.show_game_over()

# Transitions between levels should be handled here
func load_level(lvl_nbr: int) -> void:
    if precedent_level_sc:
        _unload_level(precedent_level_sc)

    if current_level_sc:
        x_offset += current_level_sc.level_width
        precedent_level_sc = current_level_sc

    print("Loading level %d @x=%d" % [level_nbr, x_offset])
    current_level_sc = load("res://levels/level_%s.tscn" % lvl_nbr).instantiate()

    if $PostFightTimer.is_stopped():
        $CameraCollision.set_destination_and_back_collision(current_level_sc.should_camera_move,
                                                            x_offset + current_level_sc.camera_where_to)
    $MinionManager.set_minimum_number_of_minions(current_level_sc.minimum_number_of_minions)

    current_level_sc.global_position.x = x_offset

    call_deferred("add_child", current_level_sc)
#end

func _unload_level(level: Level) -> void:
    print("Unloading level %s" % level.name)
    call_deferred("remove_child", level)
#end

# Called when level_ended signal is triggered
func _change_level() -> void:
    if level_nbr >= 6:
        return

    level_nbr += 1
    load_level(level_nbr)
#end

func _on_mob_died(mob: Mob) -> void:
    if mob.is_boss():
        dezoom_offset = x_offset
        $PostFightTimer.start()
        _change_level()
#end

func _on_post_fight_timer_timeout() -> void:
    $CameraCollision.set_destination_and_back_collision(current_level_sc.should_camera_move,
                                                        x_offset + current_level_sc.camera_where_to)
#end

func dezoom(delta: float) -> void:
    var level = precedent_level_sc if precedent_level_sc else current_level_sc
    var zoom_target = 0.67
    var dezoom_value = delta * (1.0 - zoom_target) / $PostFightTimer.wait_time
    var dezoom_vec = delta * (Vector2(dezoom_offset, -360) - $CameraCollision.global_position) / $PostFightTimer.wait_time

    if level_nbr != 6:
        var foreground: Sprite2D = level.get_node("Foreground")
        foreground.scale.x -= dezoom_value
        foreground.scale.y -= dezoom_value
        foreground.global_position -= dezoom_vec

        $Player.scale.x -= dezoom_value
        $Player.scale.y -= dezoom_value

        $MinionManager.scale.x -= dezoom_value
        $MinionManager.scale.y -= dezoom_value

        for minion in $MinionManager.get_children():
            minion.global_position += minion.global_position * dezoom_value
#end
