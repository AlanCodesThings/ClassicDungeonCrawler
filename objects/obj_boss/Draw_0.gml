// Boss HP bar across top of screen (drawn in world space — ui_manager also draws it in GUI)
// Subclasses call event_inherited() to get this bar
draw_health_bar(room_width / 2 - 200, camera_get_view_y(view_camera[0]) + 18,
                400, 18, hp, max_hp, make_color_rgb(80, 0, 0), make_color_rgb(230, 60, 0));
