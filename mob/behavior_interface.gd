extends Node

class_name BehaviorInterface

#-----------------------------------------------------------------------------------------------------------------------
signal idling
signal preparing_attack(aoe: Area2D, cast_time: float)
signal attacking(aoe: Area2D, atk_time: float)

#-----------------------------------------------------------------------------------------------------------------------
var _apm: float:
    set = set_apm
var _food_drop: int:
    set = set_food_drop
var _aoe_range: int:
    set = set_aoe_range
var _aoe_size: Vector2:
    set = set_aoe_size

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    ## Only to remove unused signals warnings. Method is not even called at runtime
    idling.is_null()
    preparing_attack.is_null()
    attacking.is_null()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_mob_died():
    pass
#end

#-----------------------------------------------------------------------------------------------------------------------
func set_apm(data: float):
    _apm = data
#end

#-----------------------------------------------------------------------------------------------------------------------
func set_food_drop(data: int):
    _food_drop = data
#end

#-----------------------------------------------------------------------------------------------------------------------
func set_aoe_range(data: int):
    _aoe_range = data
#end

#-----------------------------------------------------------------------------------------------------------------------
func set_aoe_size(data: Vector2):
    _aoe_size = data
#end

#-----------------------------------------------------------------------------------------------------------------------
func kill():
    Signals.mob_died.emit(get_parent())
    _on_mob_died()
#end
