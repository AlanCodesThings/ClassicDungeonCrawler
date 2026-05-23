var bob_y = sin(current_time * 0.003 + x * 0.05) * 4;
switch (pickup_type) {
    case 0: draw_set_color(make_color_rgb(220, 50, 50));  break;
    case 1: draw_set_color(c_orange);                     break;
    case 2: draw_set_color(c_aqua);                       break;
}
draw_circle(x, y + bob_y, 12, false);
draw_set_color(c_white); draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_text(x, y + bob_y, (pickup_type == 0) ? "HP" : (pickup_type == 1 ? "ATK" : "SPD"));
draw_set_halign(fa_left); draw_set_valign(fa_top);
