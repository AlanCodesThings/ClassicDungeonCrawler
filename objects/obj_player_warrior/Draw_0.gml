var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
var bob = sin(current_time * 0.012) * 3;

// -- Legs --
draw_set_color(flash ? c_white : make_color_rgb(40, 60, 130));
draw_rectangle(x - 8, y + 6,  x - 2, y + 14 + bob,  false);
draw_rectangle(x + 2, y + 6,  x + 8, y + 14 - bob,  false);

// -- Torso (breastplate) --
draw_set_color(flash ? c_white : make_color_rgb(60, 100, 200));
draw_rectangle(x - 10, y - 8, x + 10, y + 8, false);
if (!flash) {
    draw_set_color(make_color_rgb(155, 165, 210));
    draw_rectangle(x - 6, y - 6, x + 6, y, false);
    draw_set_color(make_color_rgb(35, 50, 115));
    draw_line_width(x - 10, y + 3, x + 10, y + 3, 2);
}

// -- Pauldrons --
draw_set_color(flash ? c_white : make_color_rgb(120, 135, 185));
draw_rectangle(x - 14, y - 8, x - 10, y - 2, false);
draw_rectangle(x + 10, y - 8, x + 14, y - 2, false);

// -- Helmet --
draw_set_color(flash ? c_white : make_color_rgb(110, 125, 175));
draw_rectangle(x - 8, y - 20, x + 8, y - 8, false);
if (!flash) {
    draw_set_color(make_color_rgb(20, 20, 30));
    draw_rectangle(x - 5, y - 16, x + 5, y - 12, false);
    draw_set_color(make_color_rgb(90, 105, 155));
    draw_rectangle(x - 10, y - 15, x - 8,  y - 10, false);
    draw_rectangle(x + 8,  y - 15, x + 10, y - 10, false);
}

// -- 2H glow outline --
if (two_hand_active && !flash) {
    draw_set_color(make_color_rgb(255, 140, 30));
    draw_rectangle(x - 16, y - 22, x + 16, y + 16, true);
}

// -- Sword (thrust animation extends blade forward) --
var sw_len = two_hand_active ? 36 : 24;
var t_ext = 0; // no thrust animation in grid mode
var t_off = 0;
draw_set_color(flash ? c_white : (two_hand_active ? make_color_rgb(255, 160, 40) : make_color_rgb(205, 215, 230)));
draw_line_width(x + aim_dx * t_off + aim_dy * 3, y + aim_dy * t_off - aim_dx * 3,
                x + aim_dx * (sw_len + t_ext) + aim_dy * 3, y + aim_dy * (sw_len + t_ext) - aim_dx * 3, 4);
if (!flash) {
    draw_set_color(two_hand_active ? make_color_rgb(255, 230, 110) : make_color_rgb(155, 160, 180));
    draw_line_width(x + aim_dx * t_off - aim_dy * 3, y + aim_dy * t_off + aim_dx * 3,
                    x + aim_dx * (sw_len + t_ext) - aim_dy * 3, y + aim_dy * (sw_len + t_ext) + aim_dx * 3, 2);
    draw_set_color(make_color_rgb(150, 130, 85));
    draw_line_width(x + aim_dx * t_off + aim_dy * 8, y + aim_dy * t_off - aim_dx * 8,
                    x + aim_dx * t_off - aim_dy * 8, y + aim_dy * t_off + aim_dx * 8, 3);
}

// -- Shield --
if (shield_active) {
    var shx = x - aim_dx * 14 + aim_dy * 2;
    var shy = y - aim_dy * 14 - aim_dx * 2;
    draw_set_color(make_color_rgb(25, 145, 195));
    draw_circle(shx, shy, 13, false);
    draw_set_color(make_color_rgb(15, 90, 135));
    draw_circle(shx, shy, 13, true);
    draw_set_color(make_color_rgb(190, 235, 255));
    draw_line_width(shx - aim_dy * 8, shy + aim_dx * 8, shx + aim_dy * 8, shy - aim_dx * 8, 2);
}

// -- Charge ring --
if (charge_timer > 0) {
    var cpct = charge_timer / 180.0;
    draw_set_color(make_color_rgb(round(255 * cpct), round(200 * (1 - cpct * 0.4)), 0));
    draw_set_alpha(0.45 + cpct * 0.35);
    draw_ellipse(x - 14 - cpct * 14, y - 14 - cpct * 14, x + 14 + cpct * 14, y + 14 + cpct * 14, true);
    draw_set_alpha(0.2);
    draw_ellipse(x - 6 - cpct * 8, y - 6 - cpct * 8, x + 6 + cpct * 8, y + 6 + cpct * 8, false);
    draw_set_alpha(1.0);
}
