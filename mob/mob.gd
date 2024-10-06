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

    _current_hp = hit_points
    $AoE.scale = aoe_size

    $AggroRadius.scale.x = aggro_radius
    $AggroRadius.scale.y = aggro_radius / 2.0

    $Healthbar.show()

    if show_healthbar:
        $Healthbar.show()

    Signals.mob_hurt.connect(_on_signals_mob_hurt)
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_signals_mob_hurt(mob: Node) -> void:
    set_current_hp(_current_hp - (randi() % 2 + 1))
#end

#-----------------------------------------------------------------------------------------------------------------------
func _on_behavior_idling() -> void:
    _animation.play("idle")

    $AoE/AoE_Damage.hide();
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
    $AoE/AoE_Damage.show();
    for hit_minion in $AoE.get_overlapping_bodies():
        Signals.minion_hurt.emit(hit_minion)

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

#-----------------------------------------------------------------------------------------------------------------------
func set_current_hp(data: int) -> void:
    _current_hp = data
    $Healthbar/Foreground.scale.x = float(_current_hp) / float(hit_points)

    if _current_hp <= 0:
        _behavior.kill()
#end
