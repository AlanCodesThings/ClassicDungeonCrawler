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

// -- Swing trail (solid fan + bright arc edge) --
if (!flash && array_length(sword_trail) > 1) {
    gpu_set_blendmode(bm_add);
    var _n    = array_length(sword_trail);
    var _col  = two_hand_active ? make_color_rgb(255, 130, 0)   : make_color_rgb(80, 160, 255);
    var _edge = two_hand_active ? make_color_rgb(255, 230, 140) : make_color_rgb(210, 235, 255);
    // Filled fan — transparent at player, bright at tip arc
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(x, y, _col, 0);
    for (var _i = 0; _i < _n; _i++) {
        draw_vertex_color(sword_trail[_i].tx, sword_trail[_i].ty, _col, (_i + 1) / _n * 0.72);
    }
    draw_primitive_end();
    // Bright outer edge along the arc
    draw_set_alpha(0.9);
    draw_set_color(_edge);
    for (var _i = 0; _i < _n - 1; _i++) {
        draw_line_width(sword_trail[_i].tx, sword_trail[_i].ty,
                        sword_trail[_i+1].tx, sword_trail[_i+1].ty, 3);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1.0);
}

// -- Sword (swings through arc on attack) --
var sw_len = two_hand_active ? 36 : 24;
var _sdx, _sdy;
if (thrust_timer > 0) {
    var _t  = 1 - thrust_timer / 12.0;
    var _ca = swing_ang - swing_half + swing_half * 2 * _t;
    _sdx = lengthdir_x(1, _ca); _sdy = lengthdir_y(1, _ca);
} else if (array_length(sword_trail) > 0) {
    var _ca = swing_ang + swing_half; // hold end position while trail dissolves
    _sdx = lengthdir_x(1, _ca); _sdy = lengthdir_y(1, _ca);
} else {
    _sdx = aim_dx; _sdy = aim_dy;
}
var _px = -_sdy; var _py = _sdx; // perpendicular to blade
draw_set_color(flash ? c_white : (two_hand_active ? make_color_rgb(255, 160, 40) : make_color_rgb(205, 215, 230)));
draw_line_width(x + _px * 3,              y + _py * 3,
                x + _sdx * sw_len + _px * 3, y + _sdy * sw_len + _py * 3, 4);
if (!flash) {
    draw_set_color(two_hand_active ? make_color_rgb(255, 230, 110) : make_color_rgb(155, 160, 180));
    draw_line_width(x - _px * 3,              y - _py * 3,
                    x + _sdx * sw_len - _px * 3, y + _sdy * sw_len - _py * 3, 2);
    draw_set_color(make_color_rgb(150, 130, 85));
    draw_line_width(x + _px * 8, y + _py * 8, x - _px * 8, y - _py * 8, 3);
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

// -- Charge cone --
if (charge_timer > 0) {
    var _lvl = (charge_timer >= 90) ? 3 : ((charge_timer >= 50) ? 2 : ((charge_timer >= 20) ? 1 : 0));
    var _col;
    if      (_lvl == 3) { _col = make_color_rgb(255, 50,  0);   }
    else if (_lvl == 2) { _col = make_color_rgb(255, 140, 0);   }
    else if (_lvl == 1) { _col = make_color_rgb(255, 220, 0);   }
    else                { _col = make_color_rgb(255, 255, 140);  }
    var snap = grid_snap_dir_8(aim_dx, aim_dy);
    var cadx = snap.dx; var cady = snap.dy;
    var cpdx = -cady;   var cpdy = cadx;

    // Cone tile highlights (filled + outlined)
    if (_lvl > 0) {
        var _max_d = _lvl + 1;
        for (var _d = 1; _d <= _max_d; _d++) {
            for (var _p = -(_d - 1); _p <= (_d - 1); _p++) {
                var _tx = (grid_x + cadx * _d + cpdx * _p) * TILE_SIZE;
                var _ty = (grid_y + cady * _d + cpdy * _p) * TILE_SIZE;
                draw_set_color(_col);
                draw_set_alpha(0.12 + _lvl * 0.05);
                draw_rectangle(_tx, _ty, _tx + TILE_SIZE, _ty + TILE_SIZE, false);
                draw_set_alpha(0.5 + _lvl * 0.1);
                draw_rectangle(_tx, _ty, _tx + TILE_SIZE, _ty + TILE_SIZE, true);
            }
        }
    }

    // Pulsing aura (additive)
    gpu_set_blendmode(bm_add);
    draw_set_color(_col);
    var _pulse = 0.25 + sin(current_time * 0.018) * 0.12;
    draw_set_alpha(_pulse);
    draw_ellipse(x - 15, y - 15, x + 15, y + 15, true);

    // Spinning energy lines — more lines and faster per level
    var _lcount = 2 + _lvl;
    var _spin   = current_time * (0.004 + _lvl * 0.0025);
    draw_set_alpha(0.75);
    for (var _li = 0; _li < _lcount; _li++) {
        var _la = _spin + _li * (360 / _lcount);
        var _r2 = 14 + _lvl * 5;
        draw_line_width(x + lengthdir_x(7,   _la), y + lengthdir_y(7,   _la),
                        x + lengthdir_x(_r2, _la), y + lengthdir_y(_r2, _la), 2);
    }
    gpu_set_blendmode(bm_normal);

    // Level indicator bars (3 segments below player)
    draw_set_alpha(1.0);
    var _bw = 18; var _bh = 4; var _bg = 5;
    var _bx0 = x - (_bw * 3 + _bg * 2) * 0.5;
    for (var _bi = 0; _bi < 3; _bi++) {
        var _bx = _bx0 + _bi * (_bw + _bg);
        draw_set_color((_lvl > _bi) ? _col : make_color_rgb(45, 45, 45));
        draw_rectangle(_bx, y + 24, _bx + _bw, y + 24 + _bh, false);
        draw_set_color(make_color_rgb(170, 170, 170));
        draw_rectangle(_bx, y + 24, _bx + _bw, y + 24 + _bh, true);
    }

    draw_set_alpha(1.0);
}

// -- Charge slash projectile --
if (charge_slam_timer > 0) {
    var _prog = 1.0 - charge_slam_timer / 20.0; // 0→1 as projectile travels outward
    var _sc;
    if      (charge_slam_lvl == 3) { _sc = make_color_rgb(255, 60,  0);  }
    else if (charge_slam_lvl == 2) { _sc = make_color_rgb(255, 150, 0);  }
    else                           { _sc = make_color_rgb(255, 230, 0);  }
    var sdx   = charge_slam_dx; var sdy = charge_slam_dy;
    var spdx  = -sdy;           var spdy = sdx;
    var max_d = charge_slam_lvl + 1;

    // Leading edge position and half-width (expands like the cone: depth d → half_w = d-1 tiles)
    var _dist   = _prog * max_d * TILE_SIZE;
    var _hw     = max(0, _prog * max_d - 1) * TILE_SIZE;
    var _fx     = x + sdx * _dist;
    var _fy     = y + sdy * _dist;
    var _bright = sin(_prog * pi); // peaks at midpoint, fades at end

    gpu_set_blendmode(bm_add);
    draw_set_color(_sc);

    // Filled fan body — transparent at origin, bright at leading edge
    draw_set_alpha(1.0);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(x, y, _sc, 0.0);
    var _fan_steps = 10;
    for (var _si = 0; _si <= _fan_steps; _si++) {
        var _frac = _si / _fan_steps;
        var _vx = _fx + spdx * _hw * (_frac * 2.0 - 1.0);
        var _vy = _fy + spdy * _hw * (_frac * 2.0 - 1.0);
        draw_vertex_color(_vx, _vy, _sc, _bright * 0.6);
    }
    draw_primitive_end();

    // Bright leading edge line across the full width
    if (_hw > 1) {
        draw_set_alpha(_bright * 0.95);
        draw_line_width(_fx - spdx * _hw, _fy - spdy * _hw,
                        _fx + spdx * _hw, _fy + spdy * _hw, 5);
        // Tip sparks at the two outer corners
        draw_set_alpha(_bright * 0.7);
        draw_circle(_fx - spdx * _hw, _fy - spdy * _hw, 4, false);
        draw_circle(_fx + spdx * _hw, _fy + spdy * _hw, 4, false);
        // Motion-blur streaks trailing behind each tip
        var _streak = TILE_SIZE * 0.55;
        draw_set_alpha(_bright * 0.35);
        draw_line_width(_fx - spdx * _hw,              _fy - spdy * _hw,
                        _fx - spdx * _hw - sdx * _streak, _fy - spdy * _hw - sdy * _streak, 3);
        draw_line_width(_fx + spdx * _hw,              _fy + spdy * _hw,
                        _fx + spdx * _hw - sdx * _streak, _fy + spdy * _hw - sdy * _streak, 3);
    } else {
        // Point before the width opens up
        draw_set_alpha(_bright * 0.9);
        draw_circle(_fx, _fy, 6, false);
    }

    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1.0);
}
