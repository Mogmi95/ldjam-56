extends Node

#-----------------------------------------------------------------------------------------------------------------------
func create_food() -> Mob:
    var food = preload("res://mob/mob.tscn").instantiate()

    food.BehaviorScene = preload("res://mob/behavior_food.tscn")
    food.AnimationScene = preload("res://mob/animation_food.tscn")

    food.show_healthbar = false
    food.apm = 0
    food.hit_points = 1
    food.aoe_range = 0
    food.aggro_radius = 10
    food.aoe_size = Vector2.ZERO
    food.vitals.append(food)

    return food
#end

#-----------------------------------------------------------------------------------------------------------------------
func create_boss() -> Mob:
    var boss = preload("res://mob/mob.tscn").instantiate()

    boss.BehaviorScene = preload("res://mob/behavior_default.tscn")
    boss.AnimationScene = preload("res://mob/animation_default.tscn")

    boss.show_healthbar = true
    boss.apm = 30
    boss.hit_points = 100
    boss.aoe_range = 100
    boss.aoe_size = Vector2(4, 1)
    boss.food_drop = 4

    return boss
#end
