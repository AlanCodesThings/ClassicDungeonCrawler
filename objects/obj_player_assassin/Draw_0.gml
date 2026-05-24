var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
var _leg = (walk_t > 0) ? sin(walk_t * 0.28) * 4 : 0;
draw_set_alpha(invisible ? 0.22 : 1.0);

// -- Legs --
draw_set_color(flash ? c_white : make_color_rgb(50, 10, 60));
draw_rectangle(x - 6, y + 6, x - 1, y + 13 + _leg, false);
draw_rectangle(x + 1, y + 6, x + 6, y + 13 - _leg, false);

// -- Cape (behind body, trailing away from aim) --
if (!flash) {
    draw_set_color(make_color_rgb(35, 5, 45));
    var cpx = x - aim_dx * 8;
    var cpy = y - aim_dy * 8;
    draw_triangle(cpx + aim_dy * 9,  cpy - aim_dx * 9,
                  cpx - aim_dy * 9,  cpy + aim_dx * 9,
                  cpx - aim_dx * 14, cpy - aim_dy * 14, false);
}

// -- Body --
draw_set_color(flash ? c_white : make_color_rgb(80, 10, 90));
draw_rectangle(x - 8, y - 7, x + 8, y + 8, false);

// -- Hood --
draw_set_color(flash ? c_white : make_color_rgb(55, 5, 65));
draw_triangle(x - 9, y - 7, x + 9, y - 7, x, y - 22, false);
if (!flash) {
    draw_set_color(make_color_rgb(18, 4, 22));
    draw_circle(x, y - 13, 5, false);
    draw_set_color(make_color_rgb(200, 60, 255));
    draw_circle(x - 2, y - 14, 1, false);
    draw_circle(x + 2, y - 14, 1, false);
}

// -- Daggers --
draw_set_color(flash ? c_white : make_color_rgb(200, 210, 230));
draw_line_width(x + aim_dx * 4 + aim_dy * 7,  y + aim_dy * 4 - aim_dx * 7,
               x + aim_dx * 22 + aim_dy * 7, y + aim_dy * 22 - aim_dx * 7, 2);
draw_line_width(x + aim_dx * 4 - aim_dy * 7,  y + aim_dy * 4 + aim_dx * 7,
               x + aim_dx * 22 - aim_dy * 7, y + aim_dy * 22 + aim_dx * 7, 2);
draw_set_color(make_color_rgb(120, 80, 40));
draw_line_width(x + aim_dx * 4 + aim_dy * 7,  y + aim_dy * 4 - aim_dx * 7,
               x + aim_dx * 10 + aim_dy * 7, y + aim_dy * 10 - aim_dx * 7, 3);
draw_line_width(x + aim_dx * 4 - aim_dy * 7,  y + aim_dy * 4 + aim_dx * 7,
               x + aim_dx * 10 - aim_dy * 7, y + aim_dy * 10 + aim_dx * 7, 3);

// -- Flurry --
if (ability_dmg_cd > 0) {
    draw_set_alpha(0.65);
    var spin = current_time * 0.2;
    for (var fi = 0; fi < 4; fi++) {
        var fa = spin + fi * 90;
        draw_set_color(make_color_rgb(200, 50, 255));
        draw_line_width(x + lengthdir_x(8,  fa), y + lengthdir_y(8,  fa),
                        x + lengthdir_x(20, fa + 45), y + lengthdir_y(20, fa + 45), 2);
    }
    draw_set_alpha(invisible ? 0.22 : 1.0);
}

// -- Invisible sparkles --
if (invisible) {
    draw_set_alpha(0.65);
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_circle(x, y, 16, true);
    draw_set_alpha(0.45);
    var sp_seed = random_get_seed();
    random_set_seed(current_time div 120);
    repeat(8) {
        draw_circle(x + irandom_range(-20, 20), y + irandom_range(-20, 20), 1, false);
    }
    random_set_seed(sp_seed);
}

draw_set_alpha(1.0);
