extends Node

class_name BehaviorInterface

#-----------------------------------------------------------------------------------------------------------------------
signal idling
signal preparing_attack
signal attacking

#-----------------------------------------------------------------------------------------------------------------------
var _apm = 0.0:
    set = set_apm

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    ## Only to remove unused signals warnings. Method is not even called at runtime
    idling.is_null()
    preparing_attack.is_null()
    attacking.is_null()
#end

#-----------------------------------------------------------------------------------------------------------------------
func set_apm(data: float):
    _apm = data
#end
