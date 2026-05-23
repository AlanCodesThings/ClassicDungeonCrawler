event_inherited();
// Draw death zones first
for (var i = 0; i < array_length(death_zones); i++) {
    var dz = death_zones[i];
    draw_set_alpha(0.32);
    draw_set_color(make_color_rgb(0, 160, 0));
    draw_circle(dz.x, dz.y, dz.r, false);
    draw_set_alpha(1.0);
}
var flash = (hit_flash > 0 && hit_flash mod 2 == 0);
draw_set_color(flash ? c_white : make_color_rgb(30, 80, 20));
draw_rectangle(x - col_half_w, y - col_half_h, x + col_half_w, y + col_half_h, false);
// Hood
draw_set_color(flash ? c_white : make_color_rgb(20, 120, 10));
draw_rectangle(x - 22, y - col_half_h, x + 22, y - 16, false);
// Staff orb
draw_set_color(make_color_rgb(0, 230, 0));
draw_circle(x + col_half_w + 8, y, 8, false);
draw_set_color(c_white); draw_set_halign(fa_center);
draw_text(x, y - col_half_h - 14, "PLAGUE NECROMANCER");
draw_set_halign(fa_left);
