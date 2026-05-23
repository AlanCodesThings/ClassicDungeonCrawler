if (!surface_exists(map_surface)) render_map_surface();
draw_surface(map_surface, 0, 0);

// Telegraph overlays
var _tc = array_length(global.telegraph_tiles);
if (_tc > 0) {
	draw_set_alpha(1.0);
	for (var _ti = 0; _ti < _tc; _ti++) {
		var _t = global.telegraph_tiles[_ti];
		var _col = _t.col;
		// Urgency: override to bright red in final 0.5s
		if (_t.turns_left <= 30 && _t.dmg > 0) _col = c_red;
		var _alpha = (_t.turns_left <= 30) ? 0.60 : 0.35;
		draw_set_color(_col);
		draw_set_alpha(_alpha);
		draw_rectangle(_t.gx * TILE_SIZE, _t.gy * TILE_SIZE,
		               (_t.gx + 1) * TILE_SIZE - 1, (_t.gy + 1) * TILE_SIZE - 1, false);
		draw_set_color(c_white);
		draw_set_alpha(_alpha * 0.4);
		draw_rectangle(_t.gx * TILE_SIZE, _t.gy * TILE_SIZE,
		               (_t.gx + 1) * TILE_SIZE - 1, (_t.gy + 1) * TILE_SIZE - 1, true);
	}
}
// Smoke tile overlays
var _sc = array_length(global.smoke_tiles);
if (_sc > 0) {
	draw_set_color(make_color_rgb(120, 160, 120));
	draw_set_alpha(0.30);
	for (var _si = 0; _si < _sc; _si++) {
		var _s = global.smoke_tiles[_si];
		draw_rectangle(_s.gx * TILE_SIZE, _s.gy * TILE_SIZE,
		               (_s.gx + 1) * TILE_SIZE - 1, (_s.gy + 1) * TILE_SIZE - 1, false);
	}
}
draw_set_alpha(1.0);

// Animated torch glow (additive blending = natural warm light)
var tc = ds_list_size(torch_list) / 2;
if (tc > 0) {
	gpu_set_blendmode(bm_add);
	for (var i = 0; i < tc; i++) {
		var tx = ds_list_find_value(torch_list, i * 2);
		var ty = ds_list_find_value(torch_list, i * 2 + 1);
		var flicker = sin(current_time * 0.09 + i * 2.3) * 0.12 + 0.88;
		draw_set_color(make_color_rgb(255, 145, 25));
		draw_set_alpha(0.04 * flicker); draw_circle(tx, ty, 60, false);
		draw_set_alpha(0.09 * flicker); draw_circle(tx, ty, 38, false);
		draw_set_alpha(0.18 * flicker); draw_circle(tx, ty, 24, false);
		draw_set_alpha(0.32 * flicker); draw_circle(tx, ty, 13, false);
	}
	gpu_set_blendmode(bm_normal);
	draw_set_alpha(1.0);
}
