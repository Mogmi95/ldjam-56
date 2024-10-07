extends Node2D

class_name Mob

#-----------------------------------------------------------------------------------------------------------------------
@export var BehaviorScene: PackedScene
@export var AnimationScene: PackedScene
@export var show_healthbar = false
@export var aggro_radius = 4
@export var apm = 0.0
@export var hit_points = 5
@export var aoe_range = 0
@export var aoe_size = Vector2(0, 0)
@export var food_drop = 0
@export var vitals: Array[Node2D]

var _behavior: BehaviorInterface
var _animation: AnimatedSprite2D
var _current_hp: int:
    set = set_current_hp
var _aoes: Dictionary

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    _animation = AnimationScene.instantiate()
    _animation.z_index = 1
    add_child(_animation)

    _behavior = BehaviorScene.instantiate()
    _behavior.set_apm(apm)
    _behavior.set_aoe_range(aoe_range)
    _behavior.set_aoe_size(aoe_size)
    _behavior.idling.connect(_on_behavior_idling)
    _behavior.preparing_attack.connect(_on_behavior_preparing_attack)
    _behavior.attacking.connect(_on_behavior_attacking)
    add_child(_behavior)

    _current_hp = hit_points

    $AggroRadius.scale.x = aggro_radius
    $AggroRadius.scale.y = aggro_radius / 2.0

    if show_healthbar:
        $Healthbar.show()

    Signals.mob_hurt.connect(_on_signals_mob_hurt)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_signals_mob_hurt(mob: Mob) -> void:
    if mob == self:
        if $MobAnimationPlayer.is_playing():
            $MobAnimationPlayer.stop()
        $MobAnimationPlayer.play("hurt")
        set_current_hp(_current_hp - (randi() % 2 + 1))
#end

#-----------------------------------------------------------------------------------------------------------------------
func _process(_delta: float) -> void:
    _update_AoE_state()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_idling() -> void:
    _animation.play("idle")

    for aoe in _aoes:
        aoe.get_node("AoE_Damage").hide();
        aoe.hide();
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_preparing_attack(aoe: Area2D, cast_time: float) -> void:
    _animation.play("crouch")

    if aoe.position.x != 0:
        _animation.flip_h = aoe.position.x < 0

    aoe.get_node("AoE_Sprite").texture.gradient.set_color(0, Color(1, 1, 0))
    aoe.show()

    var timer = Timer.new()
    timer.one_shot = true
    add_child(timer)
    timer.start(cast_time)

    _aoes.get_or_add(aoe, [timer, false])
    add_child(aoe)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_attacking(aoe: Area2D, atk_time: float) -> void:
    _animation.play("attack")

    _aoes[aoe][0].start(atk_time)
    _aoes[aoe][1] = true

    aoe.get_node("AoE_Sprite").texture.gradient.set_color(0, Color(1, 1, 1))
    aoe.get_node("AoE_Damage").show();

    for hit_minion in aoe.get_overlapping_bodies():
        Signals.minion_hurt.emit(hit_minion, self)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _change_mob_color(color: Color) -> void:
    _animation.modulate = color
#end

#-----------------------------------------------------------------------------------------------------------------------
func _update_AoE_state() -> void:
    for aoe in _aoes:
        if _aoes[aoe][0].is_stopped() && _aoes[aoe][1]:
            remove_child(_aoes[aoe][0])
            _aoes.erase(aoe)
            remove_child(aoe)
        elif !_aoes[aoe][0].is_stopped() && !_aoes[aoe][1]:
            var completion = _aoes[aoe][0].time_left / _aoes[aoe][0].wait_time
            aoe.get_node("AoE_Sprite").texture.gradient.set_color(0, Color(1, completion, 0))
#end

#-----------------------------------------------------------------------------------------------------------------------
func set_current_hp(data: int) -> void:
    _current_hp = data
    $Healthbar/Foreground.scale.x = float(_current_hp) / float(hit_points)

    if _current_hp <= 0:
        _behavior.kill()
#end

#-----------------------------------------------------------------------------------------------------------------------
func is_boss() -> bool:
    return show_healthbar
#end
