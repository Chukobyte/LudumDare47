# Enemy.gd
extends KinematicBody2D

signal destroyed

enum STATE {
    FOLLOW,
    CHASE,
    DEATH
}

const TOLERANCE := Vector2(0.95, 0.95)
const CHASE_DISTANCE_THRESHOLD := 60

var follow_state_timer := SimpleTimer.new(4.0)
var chase_state_timer := SimpleTimer.new(2.0)
var death_state_timer := SimpleTimer.new(1.0)

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

var max_speed := 90
var acceleration := 15
var deceleration := Vector2(0.05, 0.05)
var velocity := Vector2(0, 0)

var animation_move_down := "MoveDown"
var animation_move_up := "MoveUp"
var animation_move_left := "MoveLeft"
var animation_move_right := "MoveRight"

var previous_player_angle := 0.0
var player_angle := 0.0

var angle_x_min := false
var angle_x_max := false
var angle_y_min := false
var angle_y_max := false

var previous_player_radians := 0.0

var track_player_turbo := false
var player : KinematicBody2D = null
var player_has_circled := false

var state : int = STATE.FOLLOW

func _ready() -> void:
    add_to_group(GroupId.ENEMIES)
    follow_state_timer.connect("timeout", self, "_on_follow_state_timer_timeout")
    chase_state_timer.connect("timeout", self, "_on_chase_state_timer_timeout")
    death_state_timer.connect("timeout", self, "_on_death_state_timer_timeout")
    add_child(follow_state_timer)
    add_child(chase_state_timer)
    add_child(death_state_timer)
    _on_chase_state_timer_timeout()
#    follow_state_timer.start()
    if player.has_turbo:
        _on_Player_turbo_triggered()

func _process(delta : float) -> void:
    if state == STATE.DEATH:
        return
    if player.has_turbo:
        player_angle = player.position.angle_to_point(position)
        var angle_diff : float = abs(player_angle - previous_player_angle)
        var dir = (player.position - position).normalized()
#        print("player_angle = %s, angle diff = %s, dir = %s" % [str(player_angle), str(angle_diff), str(dir)])
        if dir.x  > TOLERANCE.x:
           angle_x_max = true
        if dir.x < TOLERANCE.x:
            angle_x_min = true
        if dir.y > TOLERANCE.y:
            angle_y_max = true
        if dir.y < TOLERANCE.y:
            angle_y_min = true
        if angle_x_max && angle_x_min && angle_y_max && angle_y_min:
            player_has_circled = true

    if velocity.x > 0:
        animated_sprite.play(animation_move_right)
    elif velocity.x < 0:
        animated_sprite.play(animation_move_right)
    if velocity.y > 0:
        animated_sprite.play(animation_move_down)
    elif velocity.y < 0:
        animated_sprite.play(animation_move_up)

func _physics_process(delta) -> void:
    var distance := player.position.distance_to(position)
    var dir = (player.position - position).normalized()
    var current_max_speed := max_speed
    match state:
        STATE.FOLLOW:
            if distance <= CHASE_DISTANCE_THRESHOLD:
                dir = -dir
        STATE.CHASE:
            current_max_speed += 25
        STATE.DEATH:
            velocity = Vector2()
            rotation_degrees += 5
    velocity.x = clamp(velocity.x + (dir.x * acceleration), -current_max_speed, current_max_speed)
    velocity.y = clamp(velocity.y + (dir.y * acceleration), -current_max_speed, current_max_speed)
#        match randi() % 4:
#            0:
#                velocity.x -= 5
#            1:
#                velocity.x += 5
#            2:
#                velocity.y -= 5
#            3:
#                velocity.y += 5
    velocity = move_and_slide(velocity)

func _on_follow_state_timer_timeout() -> void:
    state = STATE.CHASE
#    chase_state_timer.start()
    chase_state_timer.random_start(3, 6)

func _on_chase_state_timer_timeout() -> void:
    state = STATE.FOLLOW
    follow_state_timer.random_start(3, 6)
#    follow_state_timer.start()

func _on_death_state_timer_timeout() -> void:
    queue_free()

func _on_Player_turbo_triggered() -> void:
    previous_player_angle = player.position.angle_to_point(position)
    player_has_circled = false
#    print("previous_player_angle = %s" % str(previous_player_angle))

func _on_Player_loop_enclosed() -> void:
    if player_has_circled:
        emit_signal("destroyed")
        state = STATE.DEATH
        death_state_timer.start()
        player_has_circled = false
        angle_x_max = false
        angle_x_min = false
        angle_y_max = false
        angle_y_min = false
