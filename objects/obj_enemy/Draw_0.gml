var flash = (hit_flash > 5);
draw_set_color(flash ? c_white : make_color_rgb(180, 40, 40));
draw_rectangle(x - col_half_w, y - col_half_h, x + col_half_w, y + col_half_h, false);
draw_health_bar(x - col_half_w, y - col_half_h - 9, col_half_w * 2, 5, hp, max_hp, make_color_rgb(60,0,0), c_lime);
