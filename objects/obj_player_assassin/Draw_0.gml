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
var _stabbing = (thrust_timer > 0);
var _ext_a, _ext_b, _perp_x, _perp_y, _adx_a, _ady_a, _adx_b, _ady_b;
if (flurry_active) {
    // One stab per hit (6 total), synced to the 20-frame hit interval, alternating blades
    var _elapsed   = 60 - flurry_timer;
    var _hit_idx   = _elapsed div 10;        // which hit we're in (0-5)
    var _hit_phase = _elapsed mod 10;        // frame within that hit window (0-9)
    var _ext       = sin(_hit_phase / 10.0 * pi) * 20;
    _ext_a  = (_hit_idx mod 2 == 0) ? _ext : 0;
    _ext_b  = (_hit_idx mod 2 == 1) ? _ext : 0;
    _perp_x = flurry_ady;  _perp_y = -flurry_adx;
    _adx_a  = flurry_adx;  _ady_a  =  flurry_ady;
    _adx_b  = flurry_adx;  _ady_b  =  flurry_ady;
} else if (_stabbing) {
    var _ext = sin((1 - thrust_timer / 10.0) * pi) * 18;
    _ext_a  = _ext;       _ext_b  = _ext;
    _perp_x = swing_ady;  _perp_y = -swing_adx;
    _adx_a  = lengthdir_x(1, swing_ang_a); _ady_a = lengthdir_y(1, swing_ang_a);
    _adx_b  = lengthdir_x(1, swing_ang_b); _ady_b = lengthdir_y(1, swing_ang_b);
} else {
    _ext_a  = 0;      _ext_b  = 0;
    _perp_x = aim_dy; _perp_y = -aim_dx;
    _adx_a  = aim_dx; _ady_a  =  aim_dy;
    _adx_b  = aim_dx; _ady_b  =  aim_dy;
}
var _len_a = 20 + _ext_a;
var _len_b = 20 + _ext_b;

// Stab speed-streaks — draw separately per blade so flurry alternation shows correctly
if (!flash && (_stabbing || flurry_active)) {
    gpu_set_blendmode(bm_add);
    if (_ext_a > 1) {
        var _sa  = _ext_a * 1.3;
        var _sal = _ext_a / 20.0;
        var _tax = x + _perp_x * 7 + _adx_a * _len_a;
        var _tay = y + _perp_y * 7 + _ady_a * _len_a;
        draw_set_color(make_color_rgb(180, 40, 230));
        draw_set_alpha(_sal * 0.45);
        draw_line_width(_tax, _tay, _tax - _adx_a * _sa, _tay - _ady_a * _sa, 9);
        draw_set_color(make_color_rgb(230, 170, 255));
        draw_set_alpha(_sal * 0.9);
        draw_line_width(_tax, _tay, _tax - _adx_a * _sa, _tay - _ady_a * _sa, 2);
    }
    if (_ext_b > 1) {
        var _sb  = _ext_b * 1.3;
        var _sbl = _ext_b / 20.0;
        var _tbx = x - _perp_x * 7 + _adx_b * _len_b;
        var _tby = y - _perp_y * 7 + _ady_b * _len_b;
        draw_set_color(make_color_rgb(180, 40, 230));
        draw_set_alpha(_sbl * 0.45);
        draw_line_width(_tbx, _tby, _tbx - _adx_b * _sb, _tby - _ady_b * _sb, 9);
        draw_set_color(make_color_rgb(230, 170, 255));
        draw_set_alpha(_sbl * 0.9);
        draw_line_width(_tbx, _tby, _tbx - _adx_b * _sb, _tby - _ady_b * _sb, 2);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(invisible ? 0.22 : 1.0);
}

// Blade A
draw_set_color(flash ? c_white : make_color_rgb(200, 210, 230));
draw_line_width(x + _perp_x * 7 + _adx_a * 4, y + _perp_y * 7 + _ady_a * 4,
                x + _perp_x * 7 + _adx_a * _len_a, y + _perp_y * 7 + _ady_a * _len_a, 2);
// Blade B
draw_line_width(x - _perp_x * 7 + _adx_b * 4, y - _perp_y * 7 + _ady_b * 4,
                x - _perp_x * 7 + _adx_b * _len_b, y - _perp_y * 7 + _ady_b * _len_b, 2);
// Handles
draw_set_color(make_color_rgb(120, 80, 40));
draw_line_width(x + _perp_x * 7 + _adx_a * 4, y + _perp_y * 7 + _ady_a * 4,
                x + _perp_x * 7 + _adx_a * 10, y + _perp_y * 7 + _ady_a * 10, 3);
draw_line_width(x - _perp_x * 7 + _adx_b * 4, y - _perp_y * 7 + _ady_b * 4,
                x - _perp_x * 7 + _adx_b * 10, y - _perp_y * 7 + _ady_b * 10, 3);


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
