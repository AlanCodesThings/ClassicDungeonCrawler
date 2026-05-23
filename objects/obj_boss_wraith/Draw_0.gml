event_inherited();
var al = (invis_timer > 0) ? 0.22 : 0.9;
draw_set_alpha(al);
var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
draw_set_color(flash ? c_white : make_color_rgb(40, 0, 60));
draw_circle(x, y, 36, false);
draw_set_color(make_color_rgb(180, 0, 255));
draw_circle(x, y, 36, true);
// Eyes
draw_set_color(make_color_rgb(200, 100, 255));
draw_circle(x - 12, y - 10, 6, false);
draw_circle(x + 12, y - 10, 6, false);
draw_set_alpha(1.0);
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text(x, y - 50, "SHADOW WRAITH");
draw_set_halign(fa_left);
