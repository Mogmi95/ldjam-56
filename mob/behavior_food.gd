extends BehaviorInterface

class_name BehaviorFood

#-----------------------------------------------------------------------------------------------------------------------
func _on_mob_died() -> void:
    Signals.food_consumed.emit(get_parent())
#end
