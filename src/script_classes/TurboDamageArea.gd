# TurboDamageArea.gd
extends Area2D

class_name TurboDamageArea

var collision := CollisionPolygon2D.new()
var life_timer := SimpleTimer.new(0.2)


func _init(polygon : PoolVector2Array):
    collision.polygon = polygon
    collision.visible = true


func _ready() -> void:
    connect("body_entered", self, "_on_Area2D_body_entered")
    life_timer.connect("timeout", self, "_on_life_timer_timeout")
#    add_child(collision)
    call_deferred("add_child", collision)
    add_child(life_timer)
    life_timer.start()

func _on_Area2D_body_entered(body : Node) -> void:
    print("%s entered damage area!" % body.get_name())
    if body.is_in_group(GroupId.ENEMIES):
        body.queue_free()

func _on_life_timer_timeout() -> void:
    queue_free()
