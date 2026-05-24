var pct = timer / max_timer;
var al  = min(1.0, pct * 2.5);
var sz, col, str;
if (is_player_damage) {
    sz  = 14;
    col = make_color_rgb(255, 50, 50);
    str = "-" + string(value);
} else if (is_crit) {
    sz  = 14;
    col = make_color_rgb(255, 140, 20);
    str = string(value) + "!";
} else {
    sz  = 10;
    col = c_white;
    str = string(value);
}

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_alpha(al * 0.55);
draw_set_color(c_black);
draw_text_transformed(x + 1, y + 1, str, sz / 10, sz / 10, 0);

draw_set_alpha(al);
draw_set_color(col);
draw_text_transformed(x, y, str, sz / 10, sz / 10, 0);

draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
