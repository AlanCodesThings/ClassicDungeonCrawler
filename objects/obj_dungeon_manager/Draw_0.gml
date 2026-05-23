if (!surface_exists(map_surface)) render_map_surface();
draw_surface(map_surface, 0, 0);

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
