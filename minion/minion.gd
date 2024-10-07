extends CharacterBody2D

const SPEED = 15000.0

const DURATION_PREPARE_ATTACK = 0.5
const DURATION_ATTACK = 1

enum State {
    IDLE,
    WALK,
    PREPARE_ATTACK,
    ATTACK,
    DAMAGED,
    DEAD,
}

var state: State = State.IDLE
var sprite

var target: Node2D
var leader: Node2D
var last_position: Vector2
var last_traveled_distances = Array()

var forced_walk = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.minion_hurt.connect(_on_minion_hurt)

    sprite = $PathToTarget/PathFollow2D/MinionSprite
    #sprite.modulate = Color(randf(), randf(), randf())
    last_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
    if state == State.DEAD:
        return
    var distance_moved_since_last_position = global_position.distance_to(last_position)
    last_position = global_position
    var has_minion_significantly_moved = is_minion_significantly_moving(distance_moved_since_last_position)

    if forced_walk:
        sprite.animation = "walk"
    else:
        $AnimationPlayer.speed_scale = leader.dash_speed
        match (state):
            State.IDLE, State.WALK:
                if has_minion_significantly_moved:
                    sprite.animation = "walk"
                    $AnimationPlayer.speed_scale = leader.dash_speed
                    sprite.flip_h = velocity.x < 0
                else:
                    sprite.animation = "idle"
            State.PREPARE_ATTACK:
                sprite.animation = "prepare_attack"
            State.ATTACK:
                pass
            State.DAMAGED:
                pass

func _physics_process(delta):
    if state == State.DEAD:
        velocity = Vector2.ZERO
        return
    if leader != null and (state == State.IDLE or state == State.WALK):
        var distance_to_leader = global_position.distance_to(leader.global_position)
        if distance_to_leader > 5:
            velocity = global_position.direction_to(leader.global_position)
            velocity *= SPEED * leader.dash_speed * delta
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
    $AttackTimer.start(randf_range(0.5, 1.5))

func _on_minion_hurt(minion: Node, source: Node):
    if minion == self:
        state = State.DEAD
        $AnimationPlayer.play("ded")

func _notify_death():
    Signals.minion_dead.emit(self)

func force_walk(value: bool = true):
    forced_walk = value

    if forced_walk:
        sprite.animation = "walk"
        sprite.frame_progress = randf()

func _on_attack_timer_timeout() -> void:
    if state == State.DEAD:
        return
    if target != null:
        state = State.PREPARE_ATTACK
        sprite.animation = "prepare_attack"

        # Turning the minion if not facing the target
        sprite.flip_h = global_position.x > target.global_position.x

        $PrepareAttackTimer.start(DURATION_PREPARE_ATTACK)

func _on_prepare_attack_timer_timeout() -> void:
    if state == State.DEAD:
        return
    if target != null:
        var vital_position = target.vitals[randi_range(0, target.vitals.size() - 1)].global_position
        state = State.ATTACK
        sprite.animation = "attack"

        # Jump to target animation
        $PathToTarget.curve.clear_points()
        var flip = 1
        if velocity.x < 0:
            flip = -1
        var in_vector = Vector2(flip * randi_range(50, 100), randi_range(300, 700))
        var out_vector = in_vector * -1

        $PathToTarget.curve.add_point(Vector2(0, 0), in_vector)
        $PathToTarget.curve.add_point(vital_position - global_position, out_vector)

        # Shadow following
        $PathForShadow.curve.clear_points()
        $PathForShadow.curve.add_point(Vector2(0, 0))
        $PathForShadow.curve.add_point(target.global_position - global_position)

        $AnimationPlayer.play("atak")
    else:
        _clear_animation()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if state == State.DEAD:
        return
    _clear_animation()

func _emit_hurt_boss_signal():
    if target != null:
        Signals.mob_hurt.emit(target)

func _clear_animation():
    state = State.IDLE
    sprite.animation = "idle"
    sprite.play()

    $AttackTimer.start(2.0)
    $PathToTarget/PathFollow2D.rotation = 0
    $PathForShadow/PathFollowShadow.rotation = 0
    $PathToTarget.curve.clear_points()
    start_random_attack_timer()

func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.name == "AggroRadius":
        if state == State.IDLE or state == State.WALK:
            set_target(area.get_parent())


func _on_area_2d_area_exited(area: Area2D) -> void:
    if area.name == "AggroRadius":
        if state == State.IDLE or state == State.WALK:
            set_target(null)
