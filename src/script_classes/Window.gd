# Window.gd
extends Reference

class_name Window

const base_size := Vector2(256, 144)
const windowed_size := Vector2(1024, 576)


static func center() -> void:
    var screen_size = OS.get_screen_size()
    var window_size = OS.get_window_size()
    OS.set_window_position(screen_size * 0.5 - window_size * 0.5)

static func set_fullscreen(fullscreen := true) -> void:
    if fullscreen:
        OS.set_window_fullscreen(fullscreen)
    else:
        set_windowed()

static func set_windowed() -> void:
    var window_size = OS.get_screen_size()

    OS.set_borderless_window(false)
    OS.set_window_fullscreen(false)

    if windowed_size <= window_size:
        OS.set_window_size(windowed_size)
        Global.get_viewport().set_size(windowed_size)
    else:
        # I set the windowed version to an arbitrary 80% of screen size here
        var scale = min(window_size.x / base_size.x, window_size.y / base_size.y) * 0.8
        var scaled_size = (base_size * scale).round()
        OS.set_window_size(scaled_size)
        Global.get_viewport().set_size(scaled_size)

    center()

static func is_full_screen() -> bool:
    return OS.window_fullscreen

static func take_screen_shot(file_path_override := "") -> void:
    var scene_tree : SceneTree = Global.get_scene_tree()
    var viewport : Viewport = Global.get_viewport()
    var file_path : String
    if !file_path_override.empty():
        file_path = file_path_override
    else:
        var os_time : Dictionary = OS.get_time()
        file_path = "user://screen_shot_%s_%s_%s.png"  \
            % [str(os_time["hour"]), str(os_time["minute"]), str(os_time["second"])]
    viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
    yield(scene_tree, "idle_frame")
    yield(scene_tree, "idle_frame")
    var image = viewport.get_texture().get_data()
    image.flip_y()
    image.save_png(file_path)
