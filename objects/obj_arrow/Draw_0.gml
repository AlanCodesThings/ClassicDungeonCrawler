var col_shaft, col_tip;
if (is_pin) {
    col_shaft = make_color_rgb(80,  180, 255);
    col_tip   = make_color_rgb(180, 230, 255);
} else if (charge_level == 3) {
    col_shaft = make_color_rgb(255, 240, 160);
    col_tip   = make_color_rgb(255, 255, 220);
} else if (charge_level == 2) {
    col_shaft = make_color_rgb(255, 155, 40);
    col_tip   = make_color_rgb(255, 210, 120);
} else {
    col_shaft = make_color_rgb(175, 150, 100);
    col_tip   = make_color_rgb(215, 200, 155);
}

var px = -dy; var py = dx; // perpendicular for fletching

// Shaft
draw_set_color(col_shaft);
draw_line_width(x - dx * 14, y - dy * 14, x, y, 2 + (charge_level == 3 ? 1 : 0));

// Tip
draw_set_color(col_tip);
draw_line_width(x, y, x + dx * 5, y + dy * 5, 3 + (charge_level >= 2 ? 1 : 0));

// Fletching
draw_set_color(make_color_rgb(190, 55, 55));
draw_line_width(x - dx * 12 + px * 4, y - dy * 12 + py * 4, x - dx * 9, y - dy * 9, 2);
draw_line_width(x - dx * 12 - px * 4, y - dy * 12 - py * 4, x - dx * 9, y - dy * 9, 2);

// Additive glow trail for charged shots
if (charge_level >= 2) {
    gpu_set_blendmode(bm_add);
    draw_set_color(col_tip);
    draw_set_alpha(charge_level == 3 ? 0.35 : 0.20);
    draw_circle(x, y, 5 + charge_level, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1.0);
}
