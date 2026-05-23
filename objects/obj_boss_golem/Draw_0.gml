event_inherited();
var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
// Body
draw_set_color(flash ? c_white : make_color_rgb(120, 100, 80));
draw_rectangle(x - 44, y - 44, x + 44, y + 44, false);
// Head
draw_set_color(flash ? c_white : make_color_rgb(90, 75, 60));
draw_rectangle(x - 28, y - 44, x + 28, y - 16, false);
// Eyes
draw_set_color(c_red);
draw_circle(x - 12, y - 34, 7, false);
draw_circle(x + 12, y - 34, 7, false);
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text(x, y - 58, "STONE COLOSSUS");
draw_set_halign(fa_left);
