var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
var _leg = (walk_t > 0) ? sin(walk_t * 0.28) * 5 : 0;

// -- Legs --
draw_set_color(flash ? c_white : make_color_rgb(40, 60, 130));
draw_rectangle(x - 8, y + 6,  x - 2, y + 14 + _leg,  false);
draw_rectangle(x + 2, y + 6,  x + 8, y + 14 - _leg,  false);

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

// -- Sword trail + swing arc --
var _base_ang = point_direction(0, 0, aim_dx, aim_dy);
var _progress = (thrust_timer > 0) ? (1.0 - thrust_timer / 12.0) : 0;
var _arc      = two_hand_active ? 160.0 : 80.0;
var _swing    = (_progress - 0.5) * _arc;
var _sword_ang = _base_ang + _swing;
var _sw_len   = two_hand_active ? 36 : 24;
var _t_ext    = round(sin(_progress * pi) * (two_hand_active ? 20 : 14));
var _sdx = lengthdir_x(1, _sword_ang);
var _sdy = lengthdir_y(1, _sword_ang);

// Draw trail before sword so sword renders on top
var _tlen = array_length(sword_trail);
if (_tlen > 1) {
    for (var _ti = 0; _ti < _tlen - 1; _ti++) {
        draw_set_color(two_hand_active ? make_color_rgb(255, 210, 80) : make_color_rgb(180, 210, 255));
        draw_set_alpha((1.0 - _ti / _tlen) * 0.65);
        draw_line_width(sword_trail[_ti].tx, sword_trail[_ti].ty,
                        sword_trail[_ti+1].tx, sword_trail[_ti+1].ty, max(1, 3.5 - _ti * 0.35));
    }
}
draw_set_alpha(1.0);

// Record tip this frame and manage trail
var _tip_x = x + _sdx * (_sw_len + _t_ext) + _sdy * 3;
var _tip_y = y + _sdy * (_sw_len + _t_ext) - _sdx * 3;
if (thrust_timer > 0) {
    array_insert(sword_trail, 0, {tx: _tip_x, ty: _tip_y});
    if (array_length(sword_trail) > 10) array_delete(sword_trail, array_length(sword_trail) - 1, 1);
} else {
    sword_trail = [];
}

// Draw sword
draw_set_color(flash ? c_white : (two_hand_active ? make_color_rgb(255, 160, 40) : make_color_rgb(205, 215, 230)));
draw_line_width(x + _sdy * 3,                          y - _sdx * 3,
                x + _sdx * (_sw_len + _t_ext) + _sdy * 3, y + _sdy * (_sw_len + _t_ext) - _sdx * 3, 4);
if (!flash) {
    draw_set_color(two_hand_active ? make_color_rgb(255, 230, 110) : make_color_rgb(155, 160, 180));
    draw_line_width(x - _sdy * 3,                          y + _sdx * 3,
                    x + _sdx * (_sw_len + _t_ext) - _sdy * 3, y + _sdy * (_sw_len + _t_ext) + _sdx * 3, 2);
    draw_set_color(make_color_rgb(150, 130, 85));
    draw_line_width(x + _sdy * 8, y - _sdx * 8, x - _sdy * 8, y + _sdx * 8, 3);
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

// -- Charge effect --
if (charge_active) {
    var cpct  = min(charge_timer / 60.0, 1.0);
    var pulse = sin(current_time * 0.025) * 0.18 + 0.82;
    var spin  = current_time * (0.07 + cpct * 0.10);
    var col   = make_color_rgb(255, round(130 * (1 - cpct)), 0);
    var ring_r = 24 + cpct * 22;

    // Aim-direction cell preview — shows exactly where the lance will land
    var _snap = grid_snap_dir_8(aim_dx, aim_dy);
    draw_set_color(make_color_rgb(255, 210, 60));
    for (var _ci = 1; _ci <= 3; _ci++) {
        var _cgx = grid_x + _snap.dx * _ci;
        var _cgy = grid_y + _snap.dy * _ci;
        if (!grid_is_walkable(_cgx, _cgy)) break;
        var _cal = (0.18 + cpct * 0.38) * (1 - (_ci - 1) * 0.22) * pulse;
        draw_set_alpha(_cal);
        draw_rectangle(_cgx * TILE_SIZE, _cgy * TILE_SIZE,
                       (_cgx + 1) * TILE_SIZE - 1, (_cgy + 1) * TILE_SIZE - 1, false);
        draw_set_alpha(_cal * 0.35);
        draw_rectangle(_cgx * TILE_SIZE, _cgy * TILE_SIZE,
                       (_cgx + 1) * TILE_SIZE - 1, (_cgy + 1) * TILE_SIZE - 1, true);
    }

    // Outer + inner rings
    draw_set_color(col);
    draw_set_alpha((0.55 + cpct * 0.3) * pulse);
    draw_circle(x, y, ring_r, true);
    draw_set_alpha((0.28 + cpct * 0.2) * pulse);
    draw_circle(x, y, ring_r * 0.62, true);

    // 8 spinning spikes — spin speed accelerates as charge builds
    for (var _si = 0; _si < 8; _si++) {
        var _sang  = spin + _si * 45;
        var _inner = ring_r * 0.42;
        var _outer = ring_r + 10 + cpct * 14;
        draw_set_color(col);
        draw_set_alpha((0.6 + cpct * 0.3) * pulse);
        draw_line_width(x + lengthdir_x(_inner, _sang), y + lengthdir_y(_inner, _sang),
                        x + lengthdir_x(_outer, _sang), y + lengthdir_y(_outer, _sang),
                        1.5 + cpct * 2.5);
    }

    // Additive core glow
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(255, 160, 40));
    draw_set_alpha(0.10 + cpct * 0.20);
    draw_circle(x, y, ring_r * 0.55, false);
    draw_set_alpha(0.28 + cpct * 0.32);
    draw_circle(x, y, 11, false);
    draw_set_alpha(0.55);
    draw_circle(x, y, 4, false);
    gpu_set_blendmode(bm_normal);

    draw_set_alpha(1.0);
}
