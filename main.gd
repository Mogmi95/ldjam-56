extends Node

# Starts at 1
var level_nbr: int = 0
var precedent_level_sc: Level = null
var current_level_sc: Level = null
var x_offset: int = 0
var zoom_value = 1.0
var dezoom_offset: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Signals.level_ended.connect(_change_level)
    Signals.game_over.connect(game_over)
    Signals.start_game.connect(new_game)
    Signals.restart_game.connect(retry_game)
    Signals.mob_died.connect(_on_mob_died)

    Signals.music_trigger.connect(_on_music_trigger)
    Signals.story_trigger.connect(_on_story_trigger)

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

        if !$PostFightTimer.is_stopped() and level_nbr < 6:
            dezoom(delta)
#end

func _update_hud() -> void:
    $HUD.update_dash($Player.get_dash_value())

func new_game() -> void:
    $MainMenu.hide()
    $Player.show()
    $HUD.show()
    $Player.reset_dash()
    # Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    current_level_sc = null
    $CameraCollision.position = Vector2.ZERO
    $Player.position = Vector2(1280 / 2.0, 780 / 2.0)
    level_nbr = 0
    load_level(level_nbr)
#end

func retry_game() -> void:
    print("--RETRY--")
    for level in get_children():
        if level.name.find("Level") != -1:
            _unload_level(level)

    for minion in $MinionManager.get_children():
        call_deferred("remove_child", minion)

    for mob in $MobManager.get_children():
        call_deferred("remove_child", mob)

    level_nbr = 0
    precedent_level_sc = null
    current_level_sc = null
    x_offset = 0
    zoom_value = 1.0
    dezoom_offset = 0

    new_game()
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
    if level_nbr >= 7:
        return

    level_nbr += 1
    load_level(level_nbr)
#end

func _on_mob_died(mob: Mob) -> void:
    if mob.is_boss():
        dezoom_offset = x_offset
        $PostFightTimer.start()
        _change_level()

        for minion in $MinionManager.get_children():
            minion.force_walk()
#end

func _on_post_fight_timer_timeout() -> void:
    zoom_value *= 2.0 / 3.0
    for minion in $MinionManager.get_children():
        minion.force_walk(false)
    $CameraCollision.set_destination_and_back_collision(current_level_sc.should_camera_move,
                                                        x_offset + current_level_sc.camera_where_to)
#end

func dezoom(delta: float) -> void:
    if level_nbr == 6:
        return

    var level = precedent_level_sc if precedent_level_sc else current_level_sc
    var map_zoom_target = 0.67
    var map_dezoom_value = delta * (1.0 - map_zoom_target) / $PostFightTimer.wait_time
    var map_dezoom_vec = delta * (Vector2(dezoom_offset, -360) - $CameraCollision.global_position) / $PostFightTimer.wait_time

    var foreground: Sprite2D = level.get_node("Foreground")
    foreground.scale.x -= map_dezoom_value
    foreground.scale.y -= map_dezoom_value
    foreground.global_position -= map_dezoom_vec

    var zoom_target = zoom_value * 2.0 / 3.0
    var dezoom_value = delta * (zoom_value - zoom_target) / $PostFightTimer.wait_time

    $Player.scale.x -= dezoom_value
    $Player.scale.y -= dezoom_value

    var minion_positions: Array

    for minion in $MinionManager.get_children():
        minion_positions.append(minion.global_position)

    $MinionManager.scale.x -= dezoom_value
    $MinionManager.scale.y -= dezoom_value

    for minion in $MinionManager.get_children():
        minion.global_position = minion_positions.pop_front()
#end

# Triggers

func _on_music_trigger(flag):
    match (flag):
        "first_boss":
            $"Music/Boss Too Much".volume_db = 0
        "bass":
            $"Music/Bass".volume_db = 0
        _:
            print("WARNING: UNKNOWN EVENT ", flag)

func _on_story_trigger(flag):
    match (flag):
        "first":
            Signals.start_display_dialog.emit([
                ["bird", "DEATH TO THIS WORLD!"],
                ["minion", "Rrrrrrrr!"]
            ])
        "boss_1":
            Signals.start_display_dialog.emit([
                ["cathy", "Wanna eat this hotdog, little friends?"],
            ])
        _:
            print("WARNING: UNKNOWN STORY FLAG ", flag)
