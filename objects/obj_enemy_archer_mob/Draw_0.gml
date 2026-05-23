var flash = (hit_flash > 5);
var bob   = sin(current_time * 0.013 + x * 0.01 + y * 0.01) * 2;

// -- Legs --
draw_set_color(flash ? c_white : make_color_rgb(120, 70, 25));
draw_rectangle(x - 6, y + 5, x - 1, y + 12 + bob, false);
draw_rectangle(x + 1, y + 5, x + 6, y + 12 - bob, false);

// -- Torso --
draw_set_color(flash ? c_white : make_color_rgb(145, 85, 30));
draw_rectangle(x - 8, y - 5, x + 8, y + 6, false);
if (!flash) {
    draw_set_color(make_color_rgb(100, 58, 18));
    draw_line_width(x - 8, y + 1, x + 8, y + 1, 2); // belt
}

// -- Head --
draw_set_color(flash ? c_white : make_color_rgb(190, 145, 90));
draw_circle(x, y - 11, 7, false);
if (!flash) {
    // Helmet / cap
    draw_set_color(make_color_rgb(100, 60, 20));
    draw_rectangle(x - 7, y - 19, x + 7, y - 13, false);
    draw_set_color(make_color_rgb(70, 40, 12));
    draw_rectangle(x - 9, y - 14, x + 9, y - 13, false);
    // Eye
    draw_set_color(make_color_rgb(30, 20, 10));
    draw_circle(x - 2, y - 12, 1, false);
    draw_circle(x + 2, y - 12, 1, false);
}

// -- Bow pointing at player --
if (instance_exists(global.player_inst)) {
    var ang = point_direction(x, y, global.player_inst.x, global.player_inst.y);
    var bperp_x = lengthdir_x(1, ang + 90);
    var bperp_y = lengthdir_y(1, ang + 90);
    var tip1x = x + bperp_x * 10;
    var tip1y = y + bperp_y * 10;
    var tip2x = x - bperp_x * 10;
    var tip2y = y - bperp_y * 10;
    var bow_midx = x + lengthdir_x(13, ang);
    var bow_midy = y + lengthdir_y(13, ang);
    draw_set_color(flash ? c_white : make_color_rgb(100, 60, 18));
    draw_line_width(tip1x, tip1y, bow_midx, bow_midy, 2);
    draw_line_width(tip2x, tip2y, bow_midx, bow_midy, 2);
    // Bowstring
    draw_set_color(flash ? c_white : make_color_rgb(220, 210, 190));
    draw_line(tip1x, tip1y, bow_midx, bow_midy);
    draw_line(tip2x, tip2y, bow_midx, bow_midy);
    // Aim line flash when about to shoot
    if (attack_cd < 30 && !flash) {
        draw_set_color(make_color_rgb(255, 180, 50));
        draw_set_alpha(0.5);
        draw_line(x, y, x + lengthdir_x(120, ang), y + lengthdir_y(120, ang));
        draw_set_alpha(1.0);
    }
}

// -- Pin indicator --
if (pin_timer > 0) {
    draw_set_color(make_color_rgb(80, 200, 255));
    draw_set_alpha(0.55);
    draw_rectangle(x - col_half_w - 2, y - col_half_h - 2, x + col_half_w + 2, y + col_half_h + 2, true);
    draw_set_alpha(1.0);
}
draw_health_bar(x - col_half_w, y - col_half_h - 9, col_half_w * 2, 4, hp, max_hp, make_color_rgb(60,0,0), c_lime);
