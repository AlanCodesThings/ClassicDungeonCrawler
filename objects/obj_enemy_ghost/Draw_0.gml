var flash = (hit_flash > 5);
var al    = phase_mode ? 0.3 : 0.8;
var bob   = sin(current_time * 0.010 + x * 0.01 + y * 0.01) * 4;
draw_set_alpha(al);

// -- Glow aura (phase mode) --
if (phase_mode && !flash) {
    draw_set_color(make_color_rgb(80, 80, 220));
    draw_set_alpha(al * 0.5);
    draw_circle(x, y + bob, col_half_w + 8, true);
    draw_set_alpha(al);
}

// -- Body (tall ellipse) --
draw_set_color(flash ? c_white : make_color_rgb(155, 155, 250));
draw_ellipse(x - col_half_w, y - col_half_h + bob, x + col_half_w, y + 6 + bob, false);

// -- Wispy bottom (3 lumps) --
if (!flash) {
    draw_set_color(make_color_rgb(125, 125, 215));
    var wave_t = current_time * 0.015;
    draw_circle(x - 8, y + 8 + sin(wave_t + 0.0) * 3 + bob, 5, false);
    draw_circle(x,     y + 10 + sin(wave_t + 1.0) * 3 + bob, 5, false);
    draw_circle(x + 8, y + 8 + sin(wave_t + 2.0) * 3 + bob, 5, false);
}

// -- Eyes --
if (!flash) {
    draw_set_color(make_color_rgb(230, 230, 255));
    draw_circle(x - 4, y - 4 + bob, 4, false);
    draw_circle(x + 4, y - 4 + bob, 4, false);
    draw_set_color(make_color_rgb(20, 10, 40));
    draw_circle(x - 4, y - 4 + bob, 2, false);
    draw_circle(x + 4, y - 4 + bob, 2, false);
    // Glowing iris
    draw_set_color(make_color_rgb(160, 160, 255));
    draw_circle(x - 4, y - 4 + bob, 1, false);
    draw_circle(x + 4, y - 4 + bob, 1, false);
}

draw_set_alpha(1.0);

draw_health_bar(x - col_half_w, y - col_half_h - 8 + bob, col_half_w * 2, 4, hp, max_hp, make_color_rgb(60,0,0), c_lime);
