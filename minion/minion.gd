extends CharacterBody2D

const SPEED = 15000.0

const DURATION_PREPARE_ATTACK = 0.5
const DURATION_ATTACK = 1.0

enum State {
    IDLE,
    WALK,
    PREPARE_ATTACK,
    ATTACK,
    DAMAGED,
}

var state: State = State.IDLE
var sprite

var target: Node2D
var leader: Node2D
var last_position: Vector2
var last_traveled_distances = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    sprite = $PathToTarget/PathFollow2D/MinionSprite
    last_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
    var distance_moved_since_last_position = global_position.distance_to(last_position)
    last_position = global_position
    var has_minion_significantly_moved = is_minion_significantly_moving(distance_moved_since_last_position)

    match (state):
        State.IDLE, State.WALK:
            if has_minion_significantly_moved:
                sprite.animation = "walk"
                sprite.flip_h = velocity.x < 0
            else:
                sprite.animation = "idle"
        State.PREPARE_ATTACK:
            sprite.animation = "attack"
        State.ATTACK:
            pass
        State.DAMAGED:
            pass

func _physics_process(delta):
    if state == State.IDLE or state == State.WALK:
        var distance_to_leader = global_position.distance_to(leader.global_position)
        if distance_to_leader > 5:
            velocity = global_position.direction_to(leader.global_position)
            velocity *= SPEED * delta
            # move_and_collide(velocity)
            move_and_slide()
        else:
            velocity = Vector2.ZERO

func is_minion_significantly_moving(distance_moved_since_last_position):
    last_traveled_distances.append(distance_moved_since_last_position)
    var sum = 0
    for distance in last_traveled_distances:
        sum += distance
    if last_traveled_distances.size() > 5:
        last_traveled_distances.pop_front()
    return (sum / last_traveled_distances.size()) > 1


func set_leader(new_leader: Node2D):
    self.leader = new_leader

func set_target(new_target: Node2D):
    self.target = new_target
    if target != null:
        start_random_attack_timer()

func start_random_attack_timer():
    $AttackTimer.start(randf_range(1, 3))

func die():
    hide()

func _on_attack_timer_timeout() -> void:
    if target != null:
        state = State.PREPARE_ATTACK
        sprite.animation = "prepare_attack"
        $PrepareAttackTimer.start(DURATION_PREPARE_ATTACK)

func _on_prepare_attack_timer_timeout() -> void:
    if target != null:
        state = State.ATTACK
        $PathToTarget.curve.clear_points()
        $PathToTarget.curve.add_point(Vector2(0, 0))
        $PathToTarget.curve.add_point(target.global_position - global_position)
        $AnimationPlayer.play("atak")
    else:
        state = State.IDLE

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    Signals.mob_hurt.emit(target)
    state = State.IDLE
    $AttackTimer.start(2.0)
    $PathToTarget/PathFollow2D.rotation = 0
    $PathToTarget.curve.clear_points()
    start_random_attack_timer()


func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.name == "AggroRadius":
        set_target(area.get_parent())


func _on_area_2d_area_exited(area: Area2D) -> void:
    if area.name == "AggroRadius":
       set_target(null)
