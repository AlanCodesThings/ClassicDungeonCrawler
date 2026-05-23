var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
draw_set_color(flash ? c_white : make_color_rgb(180, 40, 40));
draw_rectangle(x - col_half_w, y - col_half_h, x + col_half_w, y + col_half_h, false);
if (pin_timer > 0) {
	draw_set_color(make_color_rgb(80, 200, 255)); draw_set_alpha(0.6);
	draw_rectangle(x-col_half_w-2, y-col_half_h-2, x+col_half_w+2, y+col_half_h+2, true);
	draw_set_alpha(1.0);
}
draw_health_bar(x - col_half_w, y - col_half_h - 9, col_half_w * 2, 5, hp, max_hp, make_color_rgb(60,0,0), c_lime);
