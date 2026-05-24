var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
var _leg = (walk_t > 0) ? sin(walk_t * 0.28) * 4 : 0;

// -- Legs --
draw_set_color(flash ? c_white : make_color_rgb(30, 100, 30));
draw_rectangle(x - 6, y + 6, x - 1, y + 13 + _leg, false);
draw_rectangle(x + 1, y + 6, x + 6, y + 13 - _leg, false);

// -- Torso --
draw_set_color(flash ? c_white : make_color_rgb(45, 130, 45));
draw_rectangle(x - 8, y - 7, x + 8, y + 7, false);
if (!flash) {
    draw_set_color(make_color_rgb(110, 70, 30));
    draw_line_width(x - 8, y + 2, x + 8, y + 2, 2);
    draw_set_color(make_color_rgb(60, 155, 60));
    draw_rectangle(x - 4, y - 7, x + 4, y - 2, false);
}

// -- Quiver (on back side) --
if (!flash) {
    var qx = x - aim_dx * 9 - aim_dy * 5;
    var qy = y - aim_dy * 9 + aim_dx * 5;
    draw_set_color(make_color_rgb(120, 80, 30));
    draw_rectangle(qx - 3, qy - 7, qx + 3, qy + 5, false);
    draw_set_color(make_color_rgb(80, 50, 15));
    draw_rectangle(qx - 3, qy - 7, qx + 3, qy - 5, false);
    draw_set_color(make_color_rgb(180, 140, 70));
    draw_line(qx - 1, qy - 7, qx - 1, qy - 13);
    draw_line(qx + 1, qy - 7, qx + 1, qy - 13);
}

// -- Cap --
draw_set_color(flash ? c_white : make_color_rgb(80, 55, 20));
draw_rectangle(x - 7, y - 20, x + 7, y - 13, false);
if (!flash) {
    draw_set_color(make_color_rgb(55, 35, 10));
    draw_rectangle(x - 9, y - 14, x + 9, y - 13, false);
}

// -- Bow --
var bw = 14;
var tip1x = x + aim_dy * bw;
var tip1y = y - aim_dx * bw;
var tip2x = x - aim_dy * bw;
var tip2y = y + aim_dx * bw;
var midx = x + aim_dx * 18;
var midy = y + aim_dy * 18;
draw_set_color(flash ? c_white : make_color_rgb(140, 90, 35));
draw_line_width(tip1x, tip1y, midx, midy, 3);
draw_line_width(tip2x, tip2y, midx, midy, 3);

var string_pull = 0;
if (charge_level > 0) string_pull = (charge_level / 3.0) * 11;
if (arrow_delay > 0) string_pull = (arrow_delay / 18.0) * 6;
var strx = midx - aim_dx * string_pull;
var stry = midy - aim_dy * string_pull;
draw_set_color(flash ? c_white : make_color_rgb(220, 210, 190));
draw_line(tip1x, tip1y, strx, stry);
draw_line(tip2x, tip2y, strx, stry);

// Arrow on string + charge aura
if (charge_level > 0 || arrow_delay > 0) {
    var _acol;
    if      (charge_level == 3) _acol = make_color_rgb(255, 240, 160);
    else if (charge_level == 2) _acol = make_color_rgb(255, 160, 40);
    else                        _acol = make_color_rgb(220, 200, 120);
    if (arrow_delay > 0) _acol = make_color_rgb(200, 180, 120);
    draw_set_color(flash ? c_white : _acol);
    draw_line_width(strx, stry, strx + aim_dx * 16, stry + aim_dy * 16, 1 + charge_level);
    // Charging aura ring — grows and intensifies with level
    if (charge_level > 0 && !flash) {
        var pulse = sin(current_time * 0.03) * 0.18 + 0.82;
        draw_set_alpha(charge_level * 0.18 * pulse);
        draw_set_color(_acol);
        draw_circle(x, y, 12 + charge_level * 8, true);
        if (charge_level == 3) {
            draw_set_alpha(0.12 * pulse);
            draw_circle(x, y, 42, true);
        }
        draw_set_alpha(1.0);
    }
}

// -- Pin shot glow --
if (pin_shot_ready) {
    draw_set_color(make_color_rgb(80, 230, 255));
    draw_set_alpha(0.45);
    draw_circle(x, y, 16, true);
    draw_set_alpha(1.0);
}

// -- Ult sparkles --
if (ult_active) {
    draw_set_alpha(0.65);
    draw_set_color(c_yellow);
    var sp_seed = random_get_seed();
    random_set_seed(current_time div 60);
    repeat(6) {
        draw_circle(x + irandom_range(-22, 22), y + irandom_range(-22, 22), 2, false);
    }
    random_set_seed(sp_seed);
    draw_set_alpha(1.0);
}
