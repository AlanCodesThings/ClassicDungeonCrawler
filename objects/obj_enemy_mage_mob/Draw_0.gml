var flash = (hit_flash > 5);
var bob   = sin(current_time * 0.009 + x * 0.01 + y * 0.01) * 3;
var orb_pulse = 0.5 + sin(current_time * 0.05) * 0.5;
var orb_col   = (teleport_cd <= 0) ? make_color_rgb(round(180 * orb_pulse), round(80 * orb_pulse), 255) : make_color_rgb(60, 30, 100);

// -- Robe (wider at bottom) --
draw_set_color(flash ? c_white : make_color_rgb(45, 15, 80));
draw_rectangle(x - 8, y - 2 + bob, x + 8, y + 14 + bob, false); // upper robe
draw_rectangle(x - 12, y + 4 + bob, x + 12, y + 14 + bob, false); // lower robe (wider)
if (!flash) {
    // Robe trim
    draw_set_color(make_color_rgb(100, 40, 160));
    draw_rectangle(x - 12, y + 12 + bob, x + 12, y + 14 + bob, false);
    draw_line_width(x - 8, y - 2 + bob, x - 12, y + 4 + bob, 1);
    draw_line_width(x + 8, y - 2 + bob, x + 12, y + 4 + bob, 1);
    // Rune on chest
    draw_set_color(orb_col);
    draw_set_alpha(0.7);
    draw_circle(x, y + 4 + bob, 3, false);
    draw_set_alpha(1.0);
}

// -- Hood --
draw_set_color(flash ? c_white : make_color_rgb(60, 20, 100));
draw_circle(x, y - 10 + bob, 9, false);
if (!flash) {
    // Hood shadow/face
    draw_set_color(make_color_rgb(18, 8, 28));
    draw_circle(x, y - 10 + bob, 6, false);
    // Glowing eyes
    draw_set_color(orb_col);
    draw_circle(x - 3, y - 11 + bob, 2, false);
    draw_circle(x + 3, y - 11 + bob, 2, false);
}

// -- Staff --
if (instance_exists(global.player_inst)) {
    var ang = point_direction(x, y, global.player_inst.x, global.player_inst.y) + 50;
    var staff_x1 = x + 8;
    var staff_y1 = y + bob;
    var staff_x2 = staff_x1 + lengthdir_x(22, ang);
    var staff_y2 = staff_y1 + lengthdir_y(22, ang);
    draw_set_color(flash ? c_white : make_color_rgb(100, 65, 30));
    draw_line_width(staff_x1, staff_y1, staff_x2, staff_y2, 2);
    // Orb tip
    draw_set_color(orb_col);
    draw_set_alpha(0.85);
    draw_circle(staff_x2, staff_y2, 5, false);
    draw_set_alpha(0.4);
    draw_circle(staff_x2, staff_y2, 8, false);
    draw_set_alpha(1.0);
}

// -- Teleport flash --
if (teleport_cd > 150 && !flash) {
    draw_set_color(c_white);
    draw_set_alpha(0.35);
    draw_rectangle(x - col_half_w - 2, y - col_half_h - 2, x + col_half_w + 2, y + col_half_h + 2, true);
    draw_set_alpha(1.0);
}

draw_health_bar(x - col_half_w, y - col_half_h - 9, col_half_w * 2, 4, hp, max_hp, make_color_rgb(60,0,0), c_lime);
