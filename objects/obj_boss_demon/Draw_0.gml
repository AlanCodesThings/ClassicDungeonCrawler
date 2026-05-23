event_inherited();
var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
// Body
draw_set_color(flash ? c_white : make_color_rgb(150, 0, 0));
draw_rectangle(x - 55, y - 55, x + 55, y + 55, false);
// Head
draw_set_color(flash ? c_white : make_color_rgb(100, 0, 0));
draw_rectangle(x - 35, y - 55, x + 35, y - 22, false);
// Horns
draw_set_color(make_color_rgb(60, 0, 0));
draw_triangle(x - 30, y - 55, x - 55, y - 95, x - 12, y - 38, false);
draw_triangle(x + 30, y - 55, x + 55, y - 95, x + 12, y - 38, false);
// Three eyes
draw_set_color(make_color_rgb(255, 200, 0));
draw_circle(x - 14, y - 42, 7, false);
draw_circle(x + 14, y - 42, 7, false);
draw_circle(x, y - 32, 5, false);
// Phase glow
if (phase3) { draw_set_alpha(0.25); draw_set_color(c_red); draw_circle(x, y, 80, false); draw_set_alpha(1.0); }
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text(x, y - 70, "CHAOS DEMON LORD");
draw_set_halign(fa_left);
