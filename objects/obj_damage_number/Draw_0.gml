var pct  = timer / max_timer;
var al   = min(1.0, pct * 2.5); // fade out in last 40% of life
var sz   = is_crit ? 14 : 10;
var str  = string(value);

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Shadow
draw_set_alpha(al * 0.6);
draw_set_color(c_black);
draw_text_transformed(x + 1, y + 1, str, sz / 10, sz / 10, 0);

// Main number
draw_set_alpha(al);
if (is_crit) {
    draw_set_color(make_color_rgb(255, 120, 30));
} else {
    draw_set_color(c_white);
}
draw_text_transformed(x, y, str, sz / 10, sz / 10, 0);

draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
