extends Node2D

class_name Boss

#-----------------------------------------------------------------------------------------------------------------------
@export var BehaviorScene: PackedScene
@export var AnimationScene: PackedScene
@export var apm = 30.0
@export var hit_points = 500
@export var aoe_range = 100
@export var aoe_size = Vector2(4, 1)

var _behavior: BehaviorInterface
var _animation: AnimatedSprite2D

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    _animation = AnimationScene.instantiate()
    _animation.z_index = 1
    add_child(_animation)

    _behavior = BehaviorScene.instantiate()
    _behavior.set_apm(apm)
    _behavior.idling.connect(_on_behavior_idling)
    _behavior.preparing_attack.connect(_on_behavior_preparing_attack)
    _behavior.attacking.connect(_on_behavior_attacking)
    add_child(_behavior)

    $AoE.scale = aoe_size
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_idling() -> void:
    _animation.play("idle")

    $AoE/CollisionShape2D.hide();
    $AoE.hide();
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_preparing_attack() -> void:
    _randomize_AoE_position()

    _animation.play("crouch")

    if $AoE.position.x != 0:
        _animation.flip_h = $AoE.position.x < 0

    $AoE/Sprite2D.texture.gradient.set_color(0, Color(1, 1, 0))
    $AoE.show()
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_attacking() -> void:
    _animation.play("attack")

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
