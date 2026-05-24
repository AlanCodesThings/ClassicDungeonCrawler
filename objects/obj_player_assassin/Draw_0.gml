var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
var bob = sin(current_time * 0.018) * 2;
draw_set_alpha(invisible ? 0.22 : 1.0);

// -- Legs --
draw_set_color(flash ? c_white : make_color_rgb(50, 10, 60));
draw_rectangle(x - 6, y + 6, x - 1, y + 13 + bob, false);
draw_rectangle(x + 1, y + 6, x + 6, y + 13 - bob, false);

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

// -- Daggers (stab animation) --
// Extension: 0 → peak → 0 over thrust_timer lifetime using sine
var _stabbing = (thrust_timer > 0);
var _ext = _stabbing ? sin((1 - thrust_timer / 10.0) * pi) * 18 : 0;
var _perp_x = _stabbing ? swing_ady  : aim_dy;
var _perp_y = _stabbing ? -swing_adx : -aim_dx;
var _adx_a  = _stabbing ? lengthdir_x(1, swing_ang_a) : aim_dx;
var _ady_a  = _stabbing ? lengthdir_y(1, swing_ang_a) : aim_dy;
var _adx_b  = _stabbing ? lengthdir_x(1, swing_ang_b) : aim_dx;
var _ady_b  = _stabbing ? lengthdir_y(1, swing_ang_b) : aim_dy;
var _len    = 20 + _ext;

// Stab speed-streaks (additive, behind blades)
if (!flash && _stabbing && _ext > 1) {
    var _streak = _ext * 1.3;
    var _sal    = _ext / 18.0;
    var _tax = x + _perp_x * 7 + _adx_a * _len;
    var _tay = y + _perp_y * 7 + _ady_a * _len;
    var _tbx = x - _perp_x * 7 + _adx_b * _len;
    var _tby = y - _perp_y * 7 + _ady_b * _len;
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(180, 40, 230));
    draw_set_alpha(_sal * 0.45);
    draw_line_width(_tax, _tay, _tax - _adx_a * _streak, _tay - _ady_a * _streak, 9);
    draw_line_width(_tbx, _tby, _tbx - _adx_b * _streak, _tby - _ady_b * _streak, 9);
    draw_set_color(make_color_rgb(230, 170, 255));
    draw_set_alpha(_sal * 0.9);
    draw_line_width(_tax, _tay, _tax - _adx_a * _streak, _tay - _ady_a * _streak, 2);
    draw_line_width(_tbx, _tby, _tbx - _adx_b * _streak, _tby - _ady_b * _streak, 2);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(invisible ? 0.22 : 1.0);
}

// Blade A
draw_set_color(flash ? c_white : make_color_rgb(200, 210, 230));
draw_line_width(x + _perp_x * 7 + _adx_a * 4, y + _perp_y * 7 + _ady_a * 4,
                x + _perp_x * 7 + _adx_a * _len, y + _perp_y * 7 + _ady_a * _len, 2);
// Blade B
draw_line_width(x - _perp_x * 7 + _adx_b * 4, y - _perp_y * 7 + _ady_b * 4,
                x - _perp_x * 7 + _adx_b * _len, y - _perp_y * 7 + _ady_b * _len, 2);
// Handles
draw_set_color(make_color_rgb(120, 80, 40));
draw_line_width(x + _perp_x * 7 + _adx_a * 4, y + _perp_y * 7 + _ady_a * 4,
                x + _perp_x * 7 + _adx_a * 10, y + _perp_y * 7 + _ady_a * 10, 3);
draw_line_width(x - _perp_x * 7 + _adx_b * 4, y - _perp_y * 7 + _ady_b * 4,
                x - _perp_x * 7 + _adx_b * 10, y - _perp_y * 7 + _ady_b * 10, 3);

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
    random_set_seed(id + current_time div 120);
    repeat(8) {
        draw_circle(x + irandom_range(-20, 20), y + irandom_range(-20, 20), 1, false);
    }
    random_set_seed(sp_seed);
}

draw_set_alpha(1.0);
