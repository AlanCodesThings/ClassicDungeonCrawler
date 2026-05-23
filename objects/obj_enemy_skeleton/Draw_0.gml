var flash = (hit_flash > 5);
var bone = flash ? c_white : make_color_rgb(215, 210, 190);
var dark = flash ? c_white : make_color_rgb(170, 165, 148);
var bob  = sin(current_time * 0.015 + x * 0.01 + y * 0.01) * 2;

// -- Legs (two thin bone rects) --
draw_set_color(bone);
draw_rectangle(x - 7, y + 5, x - 2, y + 12 + bob, false);
draw_rectangle(x + 2, y + 5, x + 7, y + 12 - bob, false);
// Knee joints
draw_set_color(dark);
draw_circle(x - 5, y + 8, 2, false);
draw_circle(x + 5, y + 8, 2, false);

// -- Ribcage body --
draw_set_color(bone);
draw_rectangle(x - 9, y - 4, x + 9, y + 6, false);
if (!flash) {
    // Rib lines across torso
    draw_set_color(make_color_rgb(60, 55, 45));
    draw_line_width(x - 7, y - 2, x + 7, y - 2, 1);
    draw_line_width(x - 7, y + 1, x + 7, y + 1, 1);
    draw_line_width(x - 7, y + 4, x + 7, y + 4, 1);
    // Spine
    draw_set_color(dark);
    draw_line_width(x, y - 4, x, y + 6, 1);
}

// -- Skull --
draw_set_color(bone);
draw_circle(x, y - 12, 8, false);
if (!flash) {
    // Eye sockets
    draw_set_color(make_color_rgb(20, 15, 10));
    draw_circle(x - 3, y - 13, 2, false);
    draw_circle(x + 3, y - 13, 2, false);
    // Jaw
    draw_set_color(dark);
    draw_rectangle(x - 5, y - 5, x + 5, y - 3, false);
    draw_set_color(make_color_rgb(20, 15, 10));
    draw_line(x - 2, y - 5, x - 2, y - 3);
    draw_line(x + 0, y - 5, x + 0, y - 3);
    draw_line(x + 2, y - 5, x + 2, y - 3);
}

// -- Weapon (rusty sword toward player) --
if (instance_exists(global.player_inst)) {
    var ang = point_direction(x, y, global.player_inst.x, global.player_inst.y);
    draw_set_color(make_color_rgb(140, 120, 90));
    draw_line_width(x, y, x + lengthdir_x(20, ang), y + lengthdir_y(20, ang), 3);
    draw_set_color(make_color_rgb(90, 75, 55));
    draw_line_width(x + lengthdir_x(4, ang + 90), y + lengthdir_y(4, ang + 90),
                    x + lengthdir_x(4, ang - 90), y + lengthdir_y(4, ang - 90), 2);
}

// -- Pin indicator --
if (pin_timer > 0) {
    draw_set_color(make_color_rgb(80, 200, 255));
    draw_set_alpha(0.55);
    draw_rectangle(x - 12, y - 22, x + 12, y + 14, true);
    draw_set_alpha(1.0);
}
draw_health_bar(x - 11, y - 28, 22, 5, hp, max_hp, make_color_rgb(60,0,0), c_lime);
