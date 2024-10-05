extends Node2D

class_name Boss

#-----------------------------------------------------------------------------------------------------------------------
const AOE_OFFSET = 100

#-----------------------------------------------------------------------------------------------------------------------
@export var behavior_scene: PackedScene
@export var apm = 30.0
@export var hit_points = 500

#-----------------------------------------------------------------------------------------------------------------------
func _ready() -> void:
    behavior_scene = preload("res://boss/behavior.tscn")
    var behavior = behavior_scene.instantiate()

    behavior.set_apm(apm)
    behavior.idling.connect(_on_behavior_idling)
    behavior.preparing_attack.connect(_on_behavior_preparing_attack)
    behavior.attacking.connect(_on_behavior_attacking)

    add_child(behavior)

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
    var value = AOE_OFFSET * ((randi() & 2) - 1)

    if isHorizontal:
        $AoE.rotation_degrees = 0
        $AoE.position.x = 0
        $AoE.position.y = value
    else:
        $AoE.rotation_degrees = 90
        $AoE.position.x = value
        $AoE.position.y = 0
#end
