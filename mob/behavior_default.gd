extends BehaviorInterface

class_name BehaviorDefault

#-----------------------------------------------------------------------------------------------------------------------
var _aoe: Area2D

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    _idle()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_idle_timer_timeout() -> void:
    _prepare_attack()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_preparation_timer_timeout() -> void:
    _attack()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_attack_timer_timeout() -> void:
    _idle()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_mob_died() -> void:
    Signals.food_spawned.emit(_food_drop, get_parent().global_position)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _prepare_attack() -> void:
    _aoe = _randomize_new_AoE()
    preparing_attack.emit(_aoe, 2.0)
    $PreparationTimer.start(2.0)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _attack() -> void:
    attacking.emit(_aoe, 0.2)
    $AttackTimer.start(0.2)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _idle() -> void:
    idling.emit()
    $IdleTimer.start((60.0 / _apm) - 1.2)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _randomize_new_AoE() -> Area2D:
    var isHorizontal = randi() % 2
    var value = _aoe_range * ((randi() & 2) - 1)
    var aoe = preload("res://mob/aoe.tscn").instantiate()

    aoe.scale = _aoe_size

    if isHorizontal:
        aoe.rotation_degrees = 0
        aoe.position.x = 0
        aoe.position.y = value
    else:
        aoe.rotation_degrees = 90
        aoe.position.x = value
        aoe.position.y = 0

    return aoe
#end
