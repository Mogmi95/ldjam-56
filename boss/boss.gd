extends Node2D

class_name Boss

#-----------------------------------------------------------------------------------------------------------------------
@export var BehaviorScene: PackedScene
@export var apm = 30.0
@export var hit_points = 500
@export var aoe_range = 100

var _behavior: BehaviorInterface

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    ## FIX ME: why can´t we set scene files in editor's inspector
    #behavior = BehaviorScene.instantiate()
    _behavior = preload("res://boss/behavior_default.tscn").instantiate()

    _behavior.set_apm(apm)
    _behavior.idling.connect(_on_behavior_idling)
    _behavior.preparing_attack.connect(_on_behavior_preparing_attack)
    _behavior.attacking.connect(_on_behavior_attacking)

    add_child(_behavior)

    _on_behavior_idling()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _process(delta: float) -> void:
    delta = delta
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_idling() -> void:
    $AnimatedSprite2D.play("idle")

    $AoE/CollisionShape2D.hide();
    $AoE.hide();
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_preparing_attack() -> void:
    _randomize_AoE_position()

    $AnimatedSprite2D.play("crouch")

    if $AoE.position.x != 0:
        $AnimatedSprite2D.flip_h = $AoE.position.x < 0

    $AoE/Sprite2D.texture.gradient.set_color(0, Color(1, 1, 0))
    $AoE.show()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_attacking() -> void:
    $AnimatedSprite2D.play("attack")

    $AoE/Sprite2D.texture.gradient.set_color(0, Color(1, 0, 0))
    $AoE/CollisionShape2D.show();

#end

#-----------------------------------------------------------------------------------------------------------------------
func _randomize_AoE_position() -> void:
    var isHorizontal = randi() % 2
    var value = aoe_range * ((randi() & 2) - 1)

    if isHorizontal:
        $AoE.rotation_degrees = 0
        $AoE.position.x = 0
        $AoE.position.y = value
    else:
        $AoE.rotation_degrees = 90
        $AoE.position.x = value
        $AoE.position.y = 0
#end
