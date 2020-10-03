# Enemy.gd
extends KinematicBody2D

const TOLERANCE := Vector2(0.95, 0.95)

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


func _ready() -> void:
    add_to_group(GroupId.ENEMIES)
    if player.has_turbo:
        _on_Player_turbo_triggered()

func _process(delta : float) -> void:
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

func _physics_process(delta) -> void:
    var velocity := Vector2()
    match randi() % 4:
        0:
            velocity.x -= 5
        1:
            velocity.x += 5
        2:
            velocity.y -= 5
        3:
            velocity.y += 5
    move_and_slide(velocity)

func _on_Player_turbo_triggered() -> void:
    previous_player_angle = player.position.angle_to_point(position)
    player_has_circled = false
#    print("previous_player_angle = %s" % str(previous_player_angle))

func _on_Player_loop_enclosed() -> void:
    if player_has_circled:
        queue_free()
        player_has_circled = false
        angle_x_max = false
        angle_x_min = false
        angle_y_max = false
        angle_y_min = false
