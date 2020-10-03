# TurboTrail.gd
extends Area2D

signal enclosed(position_connected)

var life_timer := SimpleTimer.new(2.0)
var collision_enable_timer := SimpleTimer.new(0.2)
onready var collision : CollisionShape2D = $CollisionShape2D

var position_array_index := -1


func _ready() -> void:
    add_to_group(GroupId.TURBO_TRAILS)
    connect("body_entered", self, "_on_Area2D_body_entered")
    life_timer.connect("timeout", self, "_on_life_timer_timeout")
    collision_enable_timer.connect("timeout", self, "_on_collision_enable_timer_timeout")
    add_child(life_timer)
    add_child(collision_enable_timer)
#    life_timer.start()
    collision_enable_timer.start()
    collision.disabled = true

func _on_Area2D_body_entered(body : Node) -> void:
    if body.get_name() == "Player":
        emit_signal("enclosed", position_array_index)
        collision.call_deferred("set_disabled", true)
        print("trail entered")

func _on_life_timer_timeout() -> void:
    queue_free()

func _on_collision_enable_timer_timeout() -> void:
    collision.disabled = false
