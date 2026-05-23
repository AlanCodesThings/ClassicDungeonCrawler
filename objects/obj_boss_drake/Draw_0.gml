event_inherited();
var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
// Body
draw_set_color(flash ? c_white : make_color_rgb(80, 120, 200));
draw_rectangle(x - 50, y - 38, x + 50, y + 38, false);
// Head
draw_set_color(flash ? c_white : make_color_rgb(60, 100, 180));
draw_rectangle(x + 32, y - 18, x + 62, y + 18, false);
// Wings
draw_set_color(make_color_rgb(40, 80, 160));
draw_triangle(x - 50, y - 20, x - 95, y - 55, x - 10, y - 32, false);
draw_triangle(x - 50, y + 20, x - 95, y + 55, x - 10, y + 32, false);
// Eye
draw_set_color(make_color_rgb(180, 230, 255));
draw_circle(x + 48, y - 8, 6, false);
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text(x, y - 50, "FROST DRAKE");
draw_set_halign(fa_left);
